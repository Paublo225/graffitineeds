from array import array
import requests
import xlwt
from xlwt import Workbook

wb = Workbook()
  
# add_sheet is used to create sheet.
sheet1 = wb.add_sheet('Sheet 4')
  
parameters = {
  'pointId': 157,
  'priceListId': 116,
  'page': 20,
  'pageSize':1000,
  'onlyPublished': True,
  'searchString': 'аэрозольная краска',
}
url = 'https://api.sbis.ru/retail/nomenclature/list?'  
headers = {
"X-SBISAccessToken": "jBP3OX5rhHhCM7kgXr8GsNVSqAkjHGzsPkFign4vADEdOV6HaoV4vjJYVHw12OWHXxqU3QrOEPhSPrjDFFwdT9f68bwFo9tIs3kWMaLmi4hIkPrMcO7bD8"
}  
response = requests.get(url, params=parameters, headers=headers)
#print(response.json()["nomenclatures"][1]["images"][0])
arrayz = response.json()["nomenclatures"]

#sheet1.write(0, 0, 'name')
#sheet1.write(0, 2, 'id')
#sheet1.write(0, 3, 'hierarchicalId')
#sheet1.write(0, 4, 'hierarchicalParent')
#sheet1.write(0, 5, 'nomNumber')
#sheet1.write(0, 6, 'indexNumber')
#sheet1.write(0, 7, 'balance')
for i in range(0,len(arrayz)):
  sheet1.write(i,0,arrayz[i]["name"])
  sheet1.write(i,2,arrayz[i]["id"])
  sheet1.write(i,3,arrayz[i]["hierarchicalId"])
  sheet1.write(i,4,arrayz[i]["hierarchicalParent"])
  sheet1.write(i,5,arrayz[i]["nomNumber"])
  sheet1.write(i,7,arrayz[i]["cost"])
  sheet1.write(i,8,arrayz[i]["externalId"])
  
wb.save('api4.xls')