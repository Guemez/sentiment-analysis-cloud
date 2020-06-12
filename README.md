# sentiment-analysis-cloud

kubectl exec [POD-ID] -- mpiexec -f hosts -n [# of pods] python3 example2.py

El proyecto consiste en tomar una gran cantidad de tweets y hacer un sentiment analysis usando la librería de python TextBlob. Se tendrán los tweets almacenados en un archivo en un bucket, de ahí se recuperan los datos con el python, se divide la cantidad de tweets entre el número de pods que se tengan y cada pod hace el procesamiento de su tweet y subiendo los resultados a un storage de firestore (se almacena el texto del tweet y el score que recibió). Además, se obtiene el promedio del sentiment analysis de todos los tweets revisados.
En el front mostramos algunos de estos tweets con su score, además de el promedio global.
