/*
/===================================================================================
// Microsoft Information Experience Team (Server and Cloud Division)
// ==================================================================================
// Copyright (c) Microsoft Corporation.  This is an example implementation. All rights reserved.
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
// OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE.
//===================================================================================
// The example companies, organizations, products, domain names,
// e-mail addresses, logos, people, places, and events depicted
// herein are fictitious.  No association with any real company,
// organization, product, domain name, email address, logo, person,
// places, or events is intended or should be inferred.
//===================================================================================
*/

INSERT INTO [PSDatabase].[dbo].[Script]
           ([Name]
           ,[Summary]
           ,[Author]
           ,[PublishedDate]
           ,[Title]
           ,[ScriptLocator]
           ,[Rating]
           ,[Organization]
           ,[Tags]
           ,[SupportedPlatform]
           ,[ScriptCode]
           ,[ScriptId]
           ,[Locale]
           ,[Description]
           ,[Attachment]
           ,[Raters])
     VALUES
           


		   ('TestScript1','This Hello World script greets the World and is a part of the test data with the reference implementation of the Database Provider for Script Explorer.','Microsoft','7/15/2011','Test Title- Hello World','098D8EE5-1A1B-41D2-BF90-5EEC62902ABF',2.0,'1','Active Directory','Windows Server 2008;Windows Server2008 R2','# This is a hypothetical script
#
# This script just says Hello World
# Version: 1.0 
# 
echo ''Hello World''
','098D8EE5-1A1B-41D2-BF90-5EEC62902ABF','en-us', 'This Hello World script only writes to the console. It does not print or access any external resources other than the console. 
', 'no', '23'),

		   ('TestScript2','This Hello Planet script greets the Planet and is a part of the test data with the reference implementation of the Database Provider for Script Explorer.','Microsoft','7/18/2011','Test Title- Hello Planet','A68D3E96-5785-4831-80BB-C0DF442066CC',2.0,'1','Active Directory','Windows Server 2008','# This is a hypothetical script
#
# This script just says Hello Planet
# Version: 1.3 
# 
echo ''Hello Planet''
','A68D3E96-5785-4831-80BB-C0DF442066CC','en-us', 'This Hello Planet script only writes to the console. It does not print or access any external resources other than the console. 
', 'no', '12'),


		   ('TestScript3','This Hello Ladies and Gentlemen script greets all Ladies and Gentlemen and is a part of the test data with the reference implementation of the Database Provider for Script Explorer.','Microsoft','7/21/2011','Test Title- Hello Ladies and Gentlemen','BFFAA243-4CC2-4DAC-B92D-8AF159E4B633',2.0,'1','Active Directory','Windows Server 2008;Windows Server2008 R2','# This is a hypothetical script
#
# This script says Hello Ladies and Gentlemen
# Version: 2.0 
# 
echo ''Ladies and Gentlemen''
','BFFAA243-4CC2-4DAC-B92D-8AF159E4B633','en-us', 'This Hello Planet script only writes to the console. It does not print or access any external resources other than the console. 
', 'no', '18')
GO