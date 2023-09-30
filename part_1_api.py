import requests, time
import pandas as pd

def fetch_all_records(api_url, max_retries = 3, retry_delay = 1):
    headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"}
    records = []
    offset = 0
    limit = 100
    retries = 0
    while retries <= max_retries:
        params = {
            'resource_id' : '3a5b732e-9490-4629-a398-d0c414204ee0',
            'limit': limit,
            'offset':offset,
            'sort': 'end_of_week desc'
        }
        response = requests.get(api_url, headers=headers, params=params)
        if response.status_code == 200:
            data = response.json()
            records.extend(data['result']['records'])
            print(len(data['result']['records']))
            if len(data['result']['records']) < limit:
                break
            offset = offset + limit
        else:
            print("Failed to fetch the data. Status Code {}".format(response.status_code))
            if retries < max_retries:
                retries += 1
                print('Retrying in {} seconds'.format(retry_delay))
                time.sleep(retry_delay)
            else:
                print('Max attempts reached. Unable to fetch data')
                break
    return records

if __name__ == '__main__':
    api_url = "https://eservices.mas.gov.sg/api/action/datastore/search.json"
    all_records = fetch_all_records(api_url)

    data_dict = {record['end_of_week']:record for record in all_records}
    #print("Total records {}".format(len(data_dict)))
    df = pd.DataFrame.from_dict(data_dict)
    df.to_csv(r'exchange_rate_data.csv', index=True, header=False)