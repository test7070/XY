 <%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        public class ParaIn
        {
            public string userno, namea, storeno, datea, ucceins;
            //使用者帳號,名稱,倉庫編號,盤點日期,盤點資料(產品編號1#盤點數量1,產品編號2#盤點數量2)
            //盤點數量(數量1@單位1^數量2@單位2)=1@件^5@包^10@個
        }
    
        public void Page_Load()
        {
            System.Text.Encoding encoding = System.Text.Encoding.UTF8;
            Response.ContentEncoding = encoding;
            int formSize = Request.TotalBytes;
            byte[] formData = Request.BinaryRead(formSize);
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string t_out = "";
            System.Data.DataTable dt = new System.Data.DataTable();
            try
            {
	            string t_db = HttpUtility.UrlDecode(Request.Headers["database"]);
	            if (t_db == null || t_db.Length == 0)
	                t_db = "st";
	
	            var itemIn = serializer.Deserialize<ParaIn>(encoding.GetString(formData));
	            if (itemIn == null)
	            {
	                ParaIn para = new ParaIn();

                    para.userno = "Z001";  // 使用者編號
                    para.namea = "軒威電腦";  // 使用者名稱
                    para.storeno = "A"; //倉庫編號
                    para.ucceins = "D500100027#1@Y,D520100003#1@Y^3@KG";  // 盤點資料
	                itemIn = para;
	            }
	            
	            DateTime time= DateTime.Now;
                itemIn.datea = (time.Year - 1911).ToString("000") + "/" + time.Month.ToString("00") + "/" + time.Day.ToString("00");
	             
				string DCConnectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=" + t_db;
	                
                using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(DCConnectionString))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                    connSource.Open();

                    string queryString = @"
                        declare @t_userno nvarchar(50)= @userno
                        declare @t_namea nvarchar(50)= @namea
                        declare @t_storeno nvarchar(50)= @storeno
                        declare @t_datea nvarchar(50)= @datea
                        declare @t_ucceins nvarchar(50)= @ucceins

                        declare @t_noa nvarchar(50)
                        declare @accy nvarchar(50)
                        declare @t_err nvarchar(50)='盤點失敗'

                        set @t_noa='Y'+REPLACE(@t_datea,'/','')
                        +right('000'+cast(cast(right(isnull((select top 1 noa from view_ucce where noa like 'Y'+REPLACE(@t_datea,'/','')+'%' order by noa desc),'000'),3) as int)+1 as nvarchar(10)),3)
                        set @accy=LEFT(@t_datea,3)

                        IF OBJECT_ID('tempdb..#bbs')is not null
                        BEGIN
	                        drop table #bbs
                        END

                        create table #bbs(
	                        noa nvarchar(15),
	                        noq nvarchar(10),
	                        storeno nvarchar(MAX),
	                        store nvarchar(MAX),
	                        productno nvarchar(MAX),
	                        product nvarchar(MAX),
	                        spec nvarchar(MAX),
	                        style nvarchar(MAX),
	                        unit nvarchar(MAX),
	                        mount float,--實際數量
	                        emount2 float,--帳面數量
	                        price float,
	                        total float,
	                        memo nvarchar(MAX)
                        )

                        BEGIN TRY
	                        --處理單位換算
	                        if(len(@t_ucceins)>0)
	                        begin
		                        declare @str nvarchar(MAX)=@t_ucceins+','
		                        declare @str2 nvarchar(MAX)=''
		                        declare @str3 nvarchar(MAX)=''
		                        declare @productno nvarchar(MAX)=''
		                        declare @tmount nvarchar(MAX)=''
		                        declare @mount float=0
		                        declare @inmount float=0
		                        declare @unit nvarchar(10)=''
		                        declare @xmount float=0
		                        declare @xinmount float=0
		                        declare @xunit nvarchar(10)=''
		                        declare @memo nvarchar(MAX)=''
		                        declare @noq int=1
		
		                        while(LEN(@str)>0)
		                        begin
			                        set @str2=dbo.split(@str,',',0)
			                        set @productno=dbo.split(@str2,'#',0)
			                        set @tmount=dbo.split(@str2,'#',1)+'^'
			                        set @mount=0
			                        set @unit=isnull((select unit from ucc where noa=@productno),0)
			                        set @memo=''
			                        set @inmount=isnull((select inmount from pack2s where noa=@productno and pack=@unit),1)
			                        set @inmount=case when @inmount=0 then 1 else @inmount end
			
			                        while(LEN(@tmount)>0)
			                        begin
				                        set @str3=dbo.split(@tmount,'^',0)
				                        set @xmount=cast(dbo.split(@str3,'@',0) as float)
				                        set @xunit=dbo.split(@str3,'@',1)
				                        if(@xmount>0)
				                        	set @memo=@memo+dbo.split(@str3,'@',0)+dbo.split(@str3,'@',1)
				
				                        set @xinmount=isnull((select inmount from pack2s where noa=@productno and pack=@xunit),1)
				                        set @xinmount=case when @xinmount=0 then 1 else @xinmount end
				                        set @mount=@mount+round(@xmount*@xinmount/@inmount,0)
				                        set @tmount=SUBSTRING(@tmount,CHARINDEX('^',@tmount)+1,LEN(@tmount))
			                        end
			
			                        insert #bbs(noa,noq,productno,product,spec,style,mount,unit,price,total,memo,emount2,storeno)
			                        select @t_noa,CAST(@noq as nvarchar(10)),a.noa,a.product,a.spec,a.style,@mount,a.unit,0,0,@memo,isnull(b.mount,0),@t_storeno
			                        from ucc a outer apply (select top 1 mount from stkucc(@t_datea,@t_storeno,@productno))b
			                        where a.noa=@productno
			
			                        set @str=SUBSTRING(@str,CHARINDEX(',',@str)+1,LEN(@str))
			                        set @noq=@noq+1
		                        end
		
		                        set @noq=case when len(CAST(@noq as nvarchar(10)))>3 then len(CAST(@noq as nvarchar(10))) else 3 end
		
		                        update a
		                        set noq=right(REPLICATE('0', @noq) +a.noq,@noq),store=b.store
		                        from #bbs a left join store b on a.storeno=b.noa
	                        end

	                        if((select count(*) from #bbs)>0)
	                        begin
		                        EXEC('insert ucce'+@accy+'(noa,datea,kind,storeno,store)
		                        select '''+@t_noa+''','''+@t_datea+''',''1'','''','''' ')
		
		                        EXEC('insert ucces'+@accy+'(noa,noq,storeno,store,productno,product,spec,style,unit,mount,emount2,price,total,memo,datea)
		                        select noa,noq,storeno,store,productno,product,spec,style,unit,mount,emount2,price,total,memo,'''+@t_datea+''' from #bbs ')
		
		                        set @t_err='盤點資料寫入成功'
	                        end
                        END TRY
                        BEGIN CATCH
                        END CATCH

                        select @t_err

                        IF OBJECT_ID('tempdb..#bbs')is not null
                        BEGIN
	                        drop table #bbs
                        END
					";
					
					System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                    cmd.Parameters.AddWithValue("@userno", itemIn.userno);
                    cmd.Parameters.AddWithValue("@namea", itemIn.namea);
                    cmd.Parameters.AddWithValue("@storeno", itemIn.storeno);
                    cmd.Parameters.AddWithValue("@datea", itemIn.datea);
                    cmd.Parameters.AddWithValue("@ucceins", itemIn.ucceins);
					//cmd.ExecuteNonQuery();
                    adapter.SelectCommand = cmd;
                    adapter.Fill(dt);
					connSource.Close();
				}
				
	            foreach (System.Data.DataRow r in dt.Rows)
	            {
                    t_out=System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
	            }

                t_out = (itemIn.ucceins.Length == 0 ? "盤點測試資料成功" : t_out);
				
            }
            catch (Exception ex) {
                t_out = "Error=" + ex.Message + "\r\n" + ex.StackTrace;
            }
            
            Response.Write(t_out);
        }
    </script>

