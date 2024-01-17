import requests
parameterz = {
      'pointId': 157,
      'priceListId': 116,
      'searchString': "X6059856",
 #     'withBalance': True,
      'page': 0,
      'pageSize': 10
    }
url = 'https://api.sbis.ru/retail/company/warehouses?companyId=157'  
headers = {
"X-SBISAccessToken": "jBP3OX5rhHhCM7kgXr8GsNVSqAkjHGzsPkFign4vADEdOV6HaoV4vjJYVHw12OWHXxqU3QrOEPhSPrjDFFwdT9f68bwFo9tIs3kWMaLmi4hIkPrMcO7bD8"
}  
response = requests.get(url,headers=headers)


print(response.text)