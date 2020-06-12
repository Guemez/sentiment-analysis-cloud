import numpy as np
import csv
import urllib.request
import os
from google.cloud import firestore
from mpi4py import MPI
from textblob import TextBlob
comm = MPI.COMM_WORLD
r = comm.Get_rank()
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "llaves.json"
db = firestore.Client()
if r == 0:
    data = ["hola lets test eth cahracetr limit that i can store in the parto of the db shall we","adios","como","estas", "a", "b", "c","d"]
    file = urllib.request.urlopen("https://storage.googleapis.com/mi-bucket-dani-2020/clean_data.csv")
    content = file.read().decode("utf-8")
    tweets = content.splitlines()
    #print(tweets)
    data = np.array_split(tweets, comm.size)

else:
    data = None

data = comm.scatter(data, root=0)
prom = []
for x in range(len(data)):
    #print(data[x])
    analysis = TextBlob(data[x])
    #print(analysis.sentiment)
    s = str(x) + "-" + str(r)
    prom.append(analysis.sentiment.polarity)
    doc_ref = db.collection(u'tech').document(s)
    doc_ref.set({
        u'texto': data[x],
        u'score': analysis.sentiment.polarity
    })
avr = sum(prom)/len(prom)
newData = comm.gather(avr,root=0)

if r == 0:
    final = sum(newData)/len(newData)
    doc_ref = db.collection(u'Score').document(u'tech')
    doc_ref.set({
        u'score': final
    })
    print(final)
