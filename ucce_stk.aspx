 <%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        public class ParaIn
        {
            public string storeno,productno,datea;
        }
        
        public class ParaOut
        {
            public string porductno, product, spec, style, unit, stk;//產品編號,名稱,規格,版別,多單位,庫存數量
        }
    
        public void Page_Load()
        {
            System.Text.Encoding encoding = System.Text.Encoding.UTF8;
            Response.ContentEncoding = encoding;
            int formSize = Request.TotalBytes;
            byte[] formData = Request.BinaryRead(formSize);
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string t_out = "";
            ParaOut itemOut = new ParaOut();
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
	                
	               	para.storeno="A";  // 倉庫編號
                    para.productno = "D520100003";  // 產品編號
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

                        select a.noa productno,a.product,a.spec,a.style+case when len(isnull(a.engpro,''))>0 then ' 製造規格:'+a.engpro else '' end style
                        ,case when exists (select * from pack2s where noa=a.noa and pack=a.unit)
						then stuff(isnull((select ','+pack+'@'+case when pack=a.unit then CAST(cast(round(isnull(b.mount,0)+isnull(bx.mount,0),2) as int) as nvarchar(100)) else '0' end from pack2s where noa=a.noa order by inmount desc FOR XML PATH('')),''),1,1,'')
						else a.unit+'@'+CAST(cast(round(isnull(b.mount,0)+isnull(bx.mount,0),2) as int) as nvarchar(100)) end unit
                        ,case when a.unit=isnull(c.pack,'') or c.noa is null or d.noa is null then CAST(round(isnull(b.mount,0)+isnull(bx.mount,0),2) as nvarchar(100))+a.unit
						else CAST(CAST(round(isnull(b.mount,0)+isnull(bx.mount,0),2) as int) as nvarchar(100))+a.unit+' 備註:'
						+case when FLOOR(round(isnull(b.mount,0)+isnull(bx.mount,0),2)*isnull(d.inmount,1)/isnull(c.inmount,1))>0 then cast(FLOOR(round(isnull(b.mount,0)+isnull(bx.mount,0),2)*isnull(d.inmount,1)/isnull(c.inmount,1)) as nvarchar(100))+c.pack  
						when FLOOR(round(isnull(b.mount,0)+isnull(bx.mount,0),2)*isnull(d.inmount,1)/isnull(c.inmount,1))<0 then cast(ceiling(round(isnull(b.mount,0)+isnull(bx.mount,0),2)*isnull(d.inmount,1)/isnull(c.inmount,1)) as nvarchar(100))+c.pack else '' end
                        +case when (round(isnull(b.mount,0)+isnull(bx.mount,0),2)-(FLOOR(round(isnull(b.mount,0)+isnull(bx.mount,0),2)*isnull(d.inmount,1)/isnull(c.inmount,1))*isnull(c.inmount,1)))>0 then cast((round(isnull(b.mount,0)+isnull(bx.mount,0),2)-(FLOOR(round(isnull(b.mount,0)+isnull(bx.mount,0),2)*isnull(d.inmount,1)/isnull(c.inmount,1))*isnull(c.inmount,1))) as nvarchar(100))+ a.unit else '' end
                        end stk from ucc a 
                        outer apply (select mount from stkucc(@datea,@storeno,@productno)) b
                        outer apply (select round(SUM(tranmoney2-tranmoney3),2) mount from view_vccs
						where (datea<=@datea) and productno=a.noa and (tranmoney2!=0 or tranmoney3!=0))bx
                        outer apply (select top 1 * from pack2s where noa=a.noa order by inmount desc )c
                        outer apply (select top 1 * from pack2s where noa=a.noa and pack=a.unit order by inmount desc )d
                        where a.noa=@productno
					";
					
					System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
					cmd.Parameters.AddWithValue("@storeno", itemIn.storeno);
					cmd.Parameters.AddWithValue("@datea", itemIn.datea);
					cmd.Parameters.AddWithValue("@productno", itemIn.productno);
					//cmd.ExecuteNonQuery();
                    adapter.SelectCommand = cmd;
                    adapter.Fill(dt);
					connSource.Close();
				}
				t_out = (itemIn.productno == "" ? "無產品編號" : "無產品資料");
				
	            foreach (System.Data.DataRow r in dt.Rows)
	            {
                    itemOut.porductno = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
                    itemOut.product = System.DBNull.Value.Equals(r.ItemArray[1]) ? "" : (System.String)r.ItemArray[1];
                    itemOut.spec = System.DBNull.Value.Equals(r.ItemArray[2]) ? "" : (System.String)r.ItemArray[2];
                    itemOut.style = System.DBNull.Value.Equals(r.ItemArray[3]) ? "" : (System.String)r.ItemArray[3];
                    itemOut.unit = System.DBNull.Value.Equals(r.ItemArray[4]) ? "" : (System.String)r.ItemArray[4];
                    itemOut.stk = System.DBNull.Value.Equals(r.ItemArray[5]) ? "" : (System.String)r.ItemArray[5];
	            }
				
            }
            catch (Exception ex) {
                t_out = "Error=" + ex.Message + "\r\n" + ex.StackTrace;
            }
            if (t_out == "無產品資料" && dt.Rows.Count > 0)
            {
                Response.Write(itemOut.porductno + "<br>");
                Response.Write(itemOut.product + "<br>");
                Response.Write(itemOut.spec + "<br>");
                Response.Write(itemOut.style + "<br>");
                Response.Write(itemOut.unit + "<br>");
                Response.Write(itemOut.stk + "<br>");
            }else{
            	Response.Write(t_out);
            }
        }
    </script>

