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

USE [master]
GO

/****** Object:  Database [PSDatabase]    Script Date: 03/14/2011 12:03:07 ******/
CREATE DATABASE [PSDatabase] 
GO

USE [PSDatabase]
GO

/****** Object:  Table [dbo].[Script]    Script Date: 03/29/2011 16:23:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/****** Object:  Table [dbo].[Script]    Script Date: 03/29/2011 19:06:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Script](
	[Name] [nvarchar](255) NOT NULL,
	[Summary] [nvarchar](255) NOT NULL,
	[Author] [nvarchar](255) NOT NULL,
	[PublishedDate] [datetime] NULL,
	[Title] [nvarchar](255) NOT NULL,
	[ScriptLocator] [nvarchar](255) NOT NULL,
	[Rating] [float] NULL,
	[Organization] [nvarchar](255) NULL,
	[Tags] [nvarchar](1024) NULL,
	[SupportedPlatform] [varchar](255) NULL,
	[ScriptCode] [ntext] NOT NULL,
	[ScriptId] [uniqueidentifier] NOT NULL,
	[Locale] [nvarchar](50) NOT NULL,
	[Description] [ntext] NULL,
	[Attachment] [nvarchar](4000) NULL,
	[Raters] [int] NULL,
 CONSTRAINT [PK_Content_1] PRIMARY KEY CLUSTERED 
(
	[ScriptId] ASC,
	[Locale] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE PROCEDURE [dbo].[FilterScriptsByFocusGroup] 
	@focusGroup nvarchar(100),
	@searchTerm nvarchar(200)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT	Name, Summary, Author, PublishedDate, Title, ScriptLocator, Rating, Organization, Tags, SupportedPlatform, ScriptCode, ScriptId, Locale, 
			Description, Attachment, Raters
	FROM	dbo.Script
	WHERE	(Summary LIKE '%' + @focusGroup + '%' AND Summary LIKE '%' + @searchTerm + '%') OR
			(Description LIKE '%' + @focusGroup + '%' AND Description LIKE '%' + @searchTerm + '%') OR
			(Title LIKE '%' + @focusGroup + '%' AND Title LIKE '%' + @searchTerm + '%') OR
			(ScriptCode LIKE '%' + @focusGroup + '%' AND ScriptCode LIKE '%' + @searchTerm + '%')
END

GO


CREATE PROCEDURE [dbo].[GetScripts]
	@SearchTerm nvarchar(200),
	@FocusGroups nvarchar(1000)
AS
BEGIN
	
DECLARE @POSITION int, @ITEM varchar(500)

DECLARE @RESULT TABLE
 ( 
	Name nvarchar(255),
	Summary nvarchar(255),
	Author nvarchar(255),
	PublishedDate datetime,
	Title nvarchar(255),
	ScriptLocator nvarchar(255),
	Rating float,
	Organization nvarchar(255),
	Tags nvarchar(1024),
	SupportedPlatform varchar(255),
	ScriptCode ntext,
	ScriptId uniqueidentifier,
	Locale nvarchar(50),
	Description ntext,
	Attachment nvarchar(4000),
	Raters int
 )
 
IF RIGHT(RTRIM(@FocusGroups),1) <> ','
 SET @FocusGroups = @FocusGroups  + ','
 
SET @POSITION = PATINDEX('%,%' , @FocusGroups)

WHILE @POSITION <> 0 
BEGIN
 SET @ITEM = left(@FocusGroups, @POSITION-1)
 
 INSERT INTO @result
 EXEC FilterScriptsByFocusGroup @ITEM,@SearchTerm
 
 SET @FocusGroups = STUFF(@FocusGroups, 1, @POSITION, '')
 SET @POSITION =  PATINDEX('%,%', @FocusGroups)
END

SELECT * FROM @RESULT
	
END

SET ANSI_NULLS ON


GO

CREATE PROCEDURE [dbo].[GetDetails]
	@Id AS uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

    SELECT ScriptId AS Id, Description, Author, PublishedDate, Rating, Raters, Organization, Tags, SupportedPlatform, ScriptCode FROM Script WHERE ScriptId = @Id
END
GO

/****** Object:  StoredProcedure [dbo].[AddScripts]    Script Date: 07/05/2011 11:54:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddScripts]
	@Name nvarchar(255),
	@Summary nvarchar(255),
	@Author nvarchar(255),
	@PublishedDate datetime = NULL,
	@Title nvarchar(255),
	@ScriptLocator nvarchar(255),
	@Rating float = NULL,
	@Organization nvarchar(255) = NULL,
	@Tags nvarchar(1024) = NULL,
	@SupportedPlatform nvarchar(255) = NULL,
	@ScriptCode ntext,
	@ScriptId uniqueidentifier,
	@Locale nvarchar(50),
	@Description ntext = NULL,
	@Attachment nvarchar(4000) = NULL,
	@Raters int = NULL
AS
BEGIN
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
           (@Name
           ,@Summary
           ,@Author
           ,@PublishedDate
           ,@Title
           ,@ScriptLocator
           ,@Rating
           ,@Organization
           ,@Tags
           ,@SupportedPlatform
           ,@ScriptCode
           ,@ScriptId
           ,@Locale
           ,@Description
           ,@Attachment
           ,@Raters)
END

GO