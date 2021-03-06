CREATE MASTER KEY
GO

CREATE DATABASE SCOPED CREDENTIAL StorageCredential
WITH
IDENTITY = 'SHARED ACCESS SIGNATURE'
, SECRET = '#DATA_LAKE_ACCOUNT_KEY#'
;

--DROP EXTERNAL DATA SOURCE ModelStorage
-- Create an external data source with CREDENTIAL option.
CREATE EXTERNAL DATA SOURCE ModelStorage
WITH
( LOCATION = 'wasbs://wwi-02@#DATA_LAKE_ACCOUNT_NAME#.blob.core.windows.net'
, CREDENTIAL = StorageCredential
, TYPE = HADOOP
)
;
CREATE EXTERNAL FILE FORMAT csv
WITH (
FORMAT_TYPE = DELIMITEDTEXT,
FORMAT_OPTIONS (
FIELD_TERMINATOR = ',',
STRING_DELIMITER = '',
DATE_FORMAT = '',
USE_TYPE_DEFAULT = False
)
);


CREATE EXTERNAL TABLE [wwi_ml].[MLModelExt]
(
[Model] [varbinary](max) NULL
)
WITH
(
LOCATION='/ml/onnx-hex' ,
DATA_SOURCE = ModelStorage ,
FILE_FORMAT = csv ,
REJECT_TYPE = VALUE ,
REJECT_VALUE = 0
)
GO

CREATE TABLE [wwi_ml].[MLModel]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Model] [varbinary](max) NULL,
	[Description] [varchar](200) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
)
GO
