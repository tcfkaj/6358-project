# Predictor Scraper for Linear Models Project - S&P 500 Stock Analysis
import os
os.chdir(r'C:\')
import numpy as np
import pandas as pd
import csv
import good_morning as gm
import time

reader = csv.reader(open('SP500.csv', 'r')) # SP500 list in 2018
reader = list(reader)
used = set()
sp500 = [x for sl in reader for x in sl if x not in used and (used.add(x) or True)] 
tikcount = len(sp500)

func = gm.KeyRatiosDownloader()
all_result = func.download('MSFT') # for testing only
# all_result[:] # See all variables

result_df = pd.DataFrame()
for i in range(11):
    adding = all_result[i]
    result_df = result_df.append(adding)
var_menu = list(result_df.index) # A list of all variables for choosing

'''====================================================================='''

file_name = 'sp500_predictors_run500_v2.csv' # <<< Make sure to change it for each run

run_delay = 1 # Seconds
retry_delay = 5 # Seconds
attempt_limit = 5 # No. of attempts per ticker
start_yr = '2011'
end_yr = '2017'
company_list = sp500 #[100:200] #[0:10] #['MSFT', 'FB', 'GOOGL']
#var_picks = ['Earnings Per Share USD', 'Dividends USD', 'Book Value Per Share * USD', 'Return on Assets %', 'Return on Equity %', 'Return on Invested Capital %', 'Debt/Equity', 'Revenue USD Mil']

# All NAs, run again to see updates 
#company_list = ['ARNC', 'BHGE', 'BHF', 'KO', 'DLPH', 'EVHC', 'FTV', 'HPE', 'PYPL', 'QRVO', 'VNO']

var_picks = ['Net Income USD Mil', 'Free Cash Flow USD Mil', 'Financial Leverage', 'Long-Term Debt', 'Accounts Receivable']

'''====================================================================='''

# Getting index of chosen variables
var_index = list(var_menu.index(i) for i in var_picks)

totcount = len(company_list)
print(totcount, ' Tickers Left...')
res_table = []
missing = []
wrong_delta = []
attempts = 0

for i in company_list:
    while attempts < attempt_limit:
        try:    
            result = func.download(i)
    
        except:
            attempts += 1
            print('===Failed %s: %s Times...' % (i, attempts))
            time.sleep(retry_delay)
                    
        else:
            attempts = 0
            result_df = pd.DataFrame()
            col = [i]
            for j in range(11):
                adding = result[j]
                result_df = result_df.append(adding)      
            for k in var_index:
                try:
                    if result_df[start_yr][k] == 0: # Denominator cannot be 0.
                        pdelta = float('nan')
                        col.append(pdelta)
                        wrong_delta.append(i)
                        print('===Error in pdelta', i,': var #', k)                          
                    else:
                        pdelta = (result_df[end_yr][k] - result_df[start_yr][k])/result_df[start_yr][k]
                        col.append(pdelta)
                except:
                    pdelta = float('nan')
                    col.append(pdelta)
                    wrong_delta.append(i)
                    print('===Error in pdelta', i,': var #', k)        
            break

    if attempts == attempt_limit:
        print('===Skip', i, ': Try Again Later')
        missing.append(i)
        attempts = 0

    else:
        res_table.append(col)

    totcount = totcount - 1
    print(totcount, ' Tickers Left...')
    time.sleep(run_delay)

final_result = pd.DataFrame(res_table, columns = ['Company'] + var_picks)


'''++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'''
# Run second time for the missing tickers
company_list = missing

'''Run Again For 'Missing' After =====  Except >>> res_table = []'''
missing_all = []
missing_all.append(missing)
                                                               
final_result = pd.DataFrame(res_table, columns = ['Company'] + var_picks)
    
'''++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'''



final_result.to_csv(file_name) # sep='\t' if needed

x=final_result.iloc[:,4]
y=final_result.iloc[:,5]
np.corrcoef(x, y)














