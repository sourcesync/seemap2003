#
# This python file abstracts a lot of the details of 
# loading survival analysis example data and training
# survival models for the SEEMAP2023 tutorial session.
#

#
# python packages we need
#

# math and data science packages
import random
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn_pandas import DataFrameMapper

# machine learning related packages
import torch  
import torchtuples as tt 
from pycox.datasets import metabric
from pycox.models import LogisticHazard
from pycox.evaluation import EvalSurv


# global vars
df_test = None
df_train = None
df_valid = None
train = None
val = None
durations_test = None
events_test = None
x_train = None
x_val = None
labtrans = None
net = None
batch_size = None
epochs = None
stop_criteria = None
callbacks=None
model=None

def _ranseed():
    '''This should ensure reproducibility of the sampling and trained model.'''
    v = 1234
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
    torch.manual_seed(v)
    np.random.seed(v)
    random.seed(v)
    

def get_cancer_death_data():
    '''Loads and returns the METABRIC cancer data as a pandas dataframe.'''
    
    df = metabric.read_df()
    df['patient_id'] = df.apply( lambda row: "patient_%d" % int(row.name), axis=1 )
    labeled_df = df.copy()
    labeled_df.columns = [ 'MKI67', 'EGFR', 'PGR', 'ERBB2', 'hormone trtmt', 'radiothrpy', 'chemothrpy', 'ER-pos', 'age', 'days', 'died', 'ID' ]
    return labeled_df
 

def transform_data(valid_frac=0.15,test_frac=0.15):
    '''Transform the data suitable for modeling.'''
    
    if (valid_frac<0) or (valid_frac>0.5) or (test_frac<0) or (test_frac>0.5):
        print("Invalid values")
        
    global df_test, df_train, df_valid
    global train, val
    global durations_test, events_test
    global x_train, y_train, x_test, x_val, labtrans
    
    # load data and produce split
    df = metabric.read_df()
    df['patient_id'] = df.apply( lambda row: "patient_%d" % int(row.name), axis=1 )
    labeled_df = df.copy()
    labeled_df.columns = [ 'MKI67', 'EGFR', 'PGR', 'ERBB2', 'hormone trtmt', \
                          'radiothrpy', 'chemothrpy', 'ER-pos', 'age', 'days', 'died', 'ID' ]
    df = labeled_df
    
    _ranseed()
    
    # compute the test split
    num_test = int(test_frac*df.shape[0])
    df_test = df.sample( num_test )
    df_whats_left = df.drop( df_test.index )
    
    # compute the valid split
    num_valid = int(valid_frac*df.shape[0])
    #df_val = df.sample( int(test_frac*df.shape[0]))
    df_val = df_whats_left.sample( num_valid )
    df_train = df_whats_left.drop( df_val.index)
    
    print("Spliting the data into %.1f percent training, %.1f percent validation, %.1f percent test" % \
          ( (1.0-valid_frac-test_frac)*100.0, valid_frac*100, test_frac*100) )
    
    cols_standardize = ['MKI67', 'EGFR', 'PGR', 'ERBB2', 'age']
    cols_leave = ['hormone trtmt', 'radiothrpy', 'chemothrpy', 'ER-pos']

    standardize = [([col], StandardScaler()) for col in cols_standardize]
    leave = [(col, None) for col in cols_leave]

    x_mapper = DataFrameMapper(standardize + leave)

    x_train = x_mapper.fit_transform(df_train).astype('float32')
    x_val = x_mapper.transform(df_val).astype('float32')
    x_test = x_mapper.transform(df_test).astype('float32')

    num_durations = 10

    labtrans = LogisticHazard.label_transform(num_durations)
    # labtrans = PMF.label_transform(num_durations)
    # labtrans = DeepHitSingle.label_transform(num_durations)

    #get_target = lambda df: (df['duration'].values, df['event'].values)
    get_target = lambda df: (df['days'].values, df['died'].values)
    y_train = labtrans.fit_transform(*get_target(df_train))
    y_val = labtrans.transform(*get_target(df_val))

    train = (x_train, y_train)
    val = (x_val, y_val)

    # We don't need to transform the test labels
    durations_test, events_test = get_target(df_test)
     
    return df_train, df_val, df_test

def choose_multilayer_perceptron():
    '''Create the MLP Vanilla model and return it.'''
    
    global x_train, net, model
    
    in_features = x_train.shape[1]
    num_nodes = [32, 32]
    out_features = labtrans.out_features
    batch_norm = True
    dropout = 0.1

    net = tt.practical.MLPVanilla(in_features, num_nodes, out_features, batch_norm, dropout)
    model = LogisticHazard(net, tt.optim.Adam(0.01), duration_index=labtrans.cuts)
    
    return net

def prepare_training():
    '''Prepare and return the training regime we will use later on.'''
    
    global batch_size, epochs, callbacks
    
    batch_size = 256
    epochs = 100
    stop_criteria = "early-stopping"
    callbacks = [tt.cb.EarlyStopping()]
    
    return epochs, stop_criteria

def train_model():
    '''Train the model and output epoch summaries and final plot.'''
    
    global x_train, y_train, val, labtrans
    global batch_size, epochs, callbacks, model
    
    in_features = x_train.shape[1]
    num_nodes = [32, 32]
    out_features = labtrans.out_features
    batch_norm = True
    dropout = 0.1
    
    _ranseed()
    net = tt.practical.MLPVanilla(in_features, num_nodes, out_features, batch_norm, dropout)
    model = LogisticHazard(net, tt.optim.Adam(0.01), duration_index=labtrans.cuts)
    
    batch_size = 256
    epochs = 100
    stop_criteria = "early-stopping"
    callbacks = [tt.cb.EarlyStopping()]
    
    log = model.fit(x_train, y_train, batch_size, epochs, callbacks, val_data=val)
    ax = log.plot()
    ax.set_xlabel("epochs")
    
    
def predict_survival(patients, step=False, days=None):
    '''Uses trained model to predict outcome on patients in the test set.'''
    
    global x_test, df_test, model, surv

    # a convoluted way to get the row indice of the passed patients subset
    filter_pids = list(patients["ID"])
    idxs=[]
    for idx in range(df_test.shape[0]):
        if df_test.iloc[idx]["ID"] in filter_pids:
            idxs.append(idx)
            if len(idxs)==patients.shape[0]:
                break
    
    # show step function version of survival function
    if step:
        surv = model.predict_surv_df(x_test)
        surv.iloc[:, :2].plot(drawstyle='steps-post')
        plt.ylabel('S(t | x)')
        if days:
            plt.xlim(days)
        _ = plt.xlabel('Time')
    else:
        # show smoothed version of survival function
        surv = model.interpolate(10).predict_surv_df(x_test)
        surv.iloc[:, idxs].plot(drawstyle='steps-post')
        plt.ylabel('S(t | x)')
        if days:
            plt.xlim(days)
        plt.gca().legend(labels=filter_pids)
        _ = plt.xlabel('Time')
    
    
def predict_model_concordance_index():
    '''Evaluate the model based on concordance criteria.'''
    
    global surv, durations_test, events_test
    ev = EvalSurv(surv, durations_test, events_test, censor_surv='km')
    quality = ev.concordance_td('antolini')
    percent = quality* 100.0
    return float("%.2f" % percent)