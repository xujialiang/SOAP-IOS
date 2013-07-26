SOAP-IOS
========

IOS SOAP

使用方法:
1.引用kissxml

2.获取soap信封

SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"WeatherWebService"];

NSString *SoapXML=[soaputility BuildSoapwithMethodName:@"getWeatherbyCityName" withParas:@{@"theCityName": @"上海"}];

3.获取soapAction

NSString *soapAction=[soaputility GetSoapActionByMethodName:method SoapType:SOAP];

3.得到了soap信封和SoapAction，就可以用使用http post 来提交了。

主页：[http://xujialiang.net](http://blog.xujialiang.net/pages/other/open_source_projects.html)
