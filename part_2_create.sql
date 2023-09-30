SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cf_customer](
	[cust_id] [bigint] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](100) NULL,
	[first_name] [nvarchar](50) NULL,
	[last_name] [nvarchar](50) NULL,
	[password] [nvarchar](250) NULL,
	[contactno] [nvarchar](20) NULL,
	[pwd_failed_count] [int] NOT NULL,
	[guid] [uniqueidentifier] NULL,
	[pwd_req_date] [datetime] NULL,
	[islocked] [bit] NOT NULL,
	[device] [nvarchar](50) NULL,
	[ipaddress] [nvarchar](50) NULL,
	[status] [nvarchar](50) NULL,
	[remarks] [nvarchar](max) NULL,
	[review_sys_userid] [int] NULL,
	[approved_date] [datetime] NULL,
	[last_updated] [datetime] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_cf_customer] PRIMARY KEY CLUSTERED 
(
	[cust_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [dbo].[cf_login_history](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[cust_id] [bigint] NOT NULL,
	[channel] [nvarchar](50) NULL,
	[ipaddress] [nvarchar](50) NULL,
	[login_status] [char](1) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_cf_login_history] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cf_product](
	[pid] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[price] [decimal](10, 2) NULL,
	[qty] [bigint] NULL,
	[sale_start_date] [datetime] NULL,
	[sale_end_date] [datetime] NULL,
	[status] [char](1) NULL,
	[last_updated] [datetime] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_cf_product] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cf_purchase](
	[purchase_id] [bigint] IDENTITY(1,1) NOT NULL,
	[cust_id] [bigint] NOT NULL,
	[item_count] [int] NOT NULL,
	[total_amt] [decimal](10, 2) NOT NULL,
	[purchase_date] [datetime] NULL,
	[payment_status] [nvarchar](50) NULL,
	[trx_id] [uniqueidentifier] NULL,
	[payment_method] [nvarchar](50) NULL,
	[payment_date] [datetime] NULL,
	[status] [nvarchar](50) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_cf_purchase] PRIMARY KEY CLUSTERED 
(
	[purchase_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cf_purchases_line_item](
	[line_id] [bigint] IDENTITY(1,1) NOT NULL,
	[purchase_id] [bigint] NULL,
	[pid] [bigint] NULL,
	[name] [nvarchar](50) NULL,
	[qty] [int] NULL,
	[price] [decimal](10, 2) NULL,
	[subtotal] [decimal](18, 2) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_cf_purchases_line_item] PRIMARY KEY CLUSTERED 
(
	[line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertCustomer] 
	@email nvarchar(100),
	@pwd nvarchar(20),
	@fname nvarchar(50),
	@lname nvarchar(50),
	@contactno nvarchar(50),
	@device nvarchar(50),
	@ipaddress nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	insert into cf_customer
		(
			email, password, first_name, last_name, contactno, pwd_failed_count,
			islocked, status, device, ipaddress, last_updated, create_date
		)
	values 
	(@email, PWDENCRYPT(@pwd), @fname, @lname, @contactno, 0, 0, 'Pending Approval', @device, @ipaddress, getDate(), getDate())
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Karthik Potturi		<Author,,Name>
-- Create date: 29/09/2023
-- Description:	Returns the count of successful logins for a customer id
-- =============================================
CREATE FUNCTION [dbo].[getUserLoginCount]
(
	-- Add the parameters for the function here
	@cust_id bigint
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @count int

	-- Add the T-SQL statements to compute the return value here
	set @count = (select count(id) from cf_login_history where login_status='Y' and cust_id=@cust_id)

	-- Return the result of the function
	RETURN @count

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Karthik Potturi	<Author,,Name>
-- Create date: 29/09/2023
-- Description:	Returns the count of purchases for a customer id
-- =============================================
CREATE FUNCTION [dbo].[getUserPurchaseCount]
(
	-- Add the parameters for the function here
	@cust_id bigint
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @count int

	-- Add the T-SQL statements to compute the return value here
	set @count = (select count(purchase_id) from cf_purchase where cust_id=@cust_id and status='Completed' and payment_status='Paid')

	-- Return the result of the function
	RETURN @count

END
GO
