SOAP-IOS
========

IOS SOAP

使用方法:

####1.引用kissxml（具体如何在项目中添加kissxml，这里就不写了）。

####2.将服务的WebService的wsdl文件添加到项目中
例如：将http://www.webxml.com.cn/WebServices/WeatherWebService.asmx?wsdl 另存为WeatherWebService.xml。将此文件添加到项目中，后缀名必须为xml。

####3.获取soap信封

SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"WeatherWebService"];这里的WeatherWebService是步骤2中添加的wsdl文件。不包含扩展名。

NSString *SoapXML=[soaputility BuildSoapwithMethodName:@"getWeatherbyCityName" withParas:@{@"theCityName": @"上海"}];

####4.获取soapAction

NSString *soapAction=[soaputility GetSoapActionByMethodName:method SoapType:SOAP];

####5.得到了soap信封和SoapAction，就可以用使用http post 来提交了。

主页：[http://xujialiang.net](http://blog.xujialiang.net/pages/other/open_source_projects.html)
