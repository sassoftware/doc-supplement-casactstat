/*****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                  */
/*                                                               */
/*     NAME: nmfgs1                                              */
/*    TITLE: Example for nmf Action                              */
/*  PRODUCT: VIYA Statistics                                     */
/*   SYSTEM: ALL                                                 */
/*     KEYS: Multivariate Analysis                               */
/*    PROCS: nmf action set; nmf action                          */
/*     DATA:                                                     */
/* LANGUAGE: PROC CAS                                            */
/*                                                               */
/*  SUPPORT: Ning Kang                                           */
/*     MISC:                                                     */
/*****************************************************************/

/* Example: Discovering Topics from Documents */

data mycas.sample;
   infile datalines delimiter='|' missover;
   length text $150;
   input text$ did;
   datalines;
      Reduces the cost of maintenance. Improves revenue forecast.        | 1
      Analytics holds the key to unlocking big data.                     | 2
      The cost of updates between different environments is eliminated.  | 3
      Ensures easy deployment in the cloud or on-site.                   | 4
      Organizations are turning to SAS for business analytics.           | 5
      This removes concerns about maintenance and hidden costs.          | 6
      Service-oriented and cloud-ready for many cloud infrastructures.   | 7
      Easily apply machine learning and data mining techniques to data.  | 8
      SAS Viya will address data analysis, modeling and learning.        | 9
      Helps customers reduce cost and make better decisions faster.      | 10
      Simple, powerful architecture ensures easy deployment in the cloud.| 11
      SAS is helping industries glean insights from data.                | 12
      Solve complex business problems faster than ever.                  | 13
      Shatter the barriers associated with data volume with SAS Viya.    | 14
      Casual business users, data scientists and application developers. | 15
      Serves as the basis for innovation causing revenue growth.         | 16
run;

proc cas;
   textParse.tpParse /
      table='sample'
      text='text'
      docId='did'
      offset={name='pos', replace=true};

   textParse.tpAccumulate /
      offset='pos'
      reduce=1
      stopList='en_stoplist'
      parent={name='termdoc_sparse', replace=true}
      denseParent={name='termdoc', replace=true}
      terms={name='terms', replace=true};
run;
quit;

proc cas;
   nmf.nmf /                                      /*  1  */
      table='termdoc'                             /*  2  */
      inputs={'/^_[0-9]+_/'}                      /*  3  */
      method='apg'                                /*  4  */
      rank=3                                      /*  5  */
      seed=789                                    /*  6  */
      outputW={casOut={name='W', replace=true}}   /*  7  */
      outputH={casOut={name='H', replace=true}};  /*  8  */
run;
quit;

proc cas;
   transpose.transpose /
      table='H'
      prefix='Topic'
      name='Term'
      id='_Index_'
      casout={name='H2', replace=true};

   topic=${Topic1-Topic3};
   cols='_Index_' + topic;
   coltypes=${integer, varchar, varchar, varchar};
   Topics=newtable('Topics', cols, coltypes);

   table.fetch result=r1 /
      table='terms'
      fetchVars={'_Term_', '_Termnum_'}
      sortby='_Termnum_'
      to=200;
   terms=r1.Fetch[, {'_Index_', '_Termnum_', '_Term_'}];

   table.fetch result=r2 /
      table='H2'
      fetchVars=topic
      to=100;
   t={};
   do i=1 to 3;
      c=r2.Fetch[, {'_Index_', topic[i]}];
      t[i]=sort_rev(c, topic[i]);
   end;

   row={};
   do i=1 to 10;
      row[1]=i;
      do j=1 to 3;
         idx=t[j][i]._Index_;
         num=(int64)terms[idx]._Termnum_;
         row[j+1]=terms[idx+idx-num]._Term_;
      end;
      addrow(Topics, row);
   end;

   print Topics;
run;
quit;

proc python;
   submit;

import pandas as pd
import numpy as np

# load data from the file
colname = ['userID', 'movieID', 'rating']
colpick = [0, 1, 2]
df = pd.read_csv('u.data', delimiter='\t', usecols=colpick, names=colname)

# store data in dense matrix format
nrow = max(df.loc[:, 'userID'])
ncol = max(df.loc[:, 'movieID']) + 1
mat = np.full((nrow, ncol), np.nan)

for i in range(0, nrow):
   mat[i, 0] = i+1

for idx, rowSeries in df.iterrows():
   val = rowSeries.values
   mat[val[0]-1, val[1]] = val[2]

# transfer data to a SAS data table in CAS
cols = ['UserID'] + ['M%d' %i for i in range(1,ncol)]
matdf = pd.DataFrame(mat, columns=cols)

SAS.df2sd(matdf, 'mycas.ratings')

   endsubmit;
run;

proc cas;
   nmf.nmf /
      table='ratings'
      inputs={'/^M/'}
      method={name='apg', maxIter=600}
      regularization={name='L2', alpha=5, beta=5}
      rank=19
      seed=6789
      impute={output={name='outX', replace=true}, copyVar='UserID',
             imputedRowsOnly=true, predOnly=true};
run;
quit;

proc python;
   submit;

import pandas as pd
import numpy as np
import csv

# fetch the first 10 observations
df = SAS.sd2df('mycas.outX(obs=10)')

# load information about the movies
movieDict = {}
csvFile = csv.reader(open('u.item', encoding='latin-1'), delimiter='|')
for row in csvFile:
   key = 'M' + row[0]
   movieDict[key] = row[1]

# top 10 recommended movies for a single user
row = 8
uid = df.iloc[row, 0]
rating = df.iloc[row, 1:].sort_values(ascending=False, inplace=False)
colUid = [uid]*10
colRank = np.arange(1, 11).tolist()
colMid = rating.index.tolist()[0:10]
colRate = rating.values.tolist()[0:10]
colTitle = []
for i in range(0, 10):
   colTitle.append(movieDict[rating.index[i]])

cols = ['UserID', 'Rank', 'MovieID', 'Title', 'PredictedRating']
topRating = pd.DataFrame(list(zip(colUid, colRank, colMid, colTitle, colRate)),
                         columns=cols)
SAS.df2sd(topRating, 'topRating')

# top 5 recommended movies for each of the 10 users
movies = []
for idx, rowSeries in df.iterrows():
   uid = rowSeries.pop('UserID')
   rowSeries.sort_values(ascending=False, inplace=True)
   row = [uid]
   for i in range(0, 5):
      row.append(movieDict[rowSeries.index[i]])
   movies.append(row)

cols = ['UserID', '_1_', '_2_', '_3_', '_4_', '_5_']
topRecom = pd.DataFrame(movies, columns=cols)
SAS.df2sd(topRecom, 'topRecom')

   endsubmit;
run;

proc print data=topRating;
run;

proc print data=topRecom;
run;

