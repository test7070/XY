<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        
        public class Para
        {
            public string comp;//客戶
            public string version;//版別
            public string productno;//料號
            public string noa;//單號
            public string product;//品名
            public string spec;//規格
        }
        
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load()
        {
        	string db = "st";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        		db= Request.QueryString["db"];
        	connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;
            //參數
            string t_noa = "";
            string t_tablea = "";
           
            if (Request.QueryString["noa"] != null && Request.QueryString["noa"].Length > 0)
            {
                t_noa = Request.QueryString["noa"];
            }
            if (Request.QueryString["tablea"] != null && Request.QueryString["tablea"].Length > 0)
            {
                t_tablea = Request.QueryString["tablea"];
            }
            //資料
            System.Data.DataTable dt = new System.Data.DataTable();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = "";
                if(t_tablea=="rc2"){
                	queryString = @"select b.comp,case when charindex('[',spec)>0 and charindex(']',spec)>0
									then SUBSTRING(spec,charindex('[',spec)+1,charindex(']',spec)-charindex('[',spec)-1)
									else '' end version
									,b.productno,a.noa,b.product,b.spec
									from view_rc2 a left join view_rc2s b on a.noa=b.noa
                                    where a.noa=@t_noa and exists(select * from ucc where noa=b.productno)
                                    ";
				}else{
					queryString = @"select b.namea,case when charindex('[',spec)>0 and charindex(']',spec)>0
									then SUBSTRING(spec,charindex('[',spec)+1,charindex(']',spec)-charindex('[',spec)-1)
									else '' end version
									,b.productno,a.noa,b.product,b.spec
									from view_ina a left join view_inas b on a.noa=b.noa
                                    where a.noa=@t_noa and exists(select * from ucc where noa=b.productno)
                                    ";
				}
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@t_noa", t_noa);
                adapter.SelectCommand = cmd;
                adapter.Fill(dt);
                connSource.Close();
            }
            ArrayList barcode = new ArrayList();
            foreach (System.Data.DataRow r in dt.Rows)
            {
                Para pa = new Para();
                pa.comp = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
                pa.version = System.DBNull.Value.Equals(r.ItemArray[1]) ? "" : (System.String)r.ItemArray[1];
                pa.productno = System.DBNull.Value.Equals(r.ItemArray[2]) ? "" : (System.String)r.ItemArray[2];
                pa.noa = System.DBNull.Value.Equals(r.ItemArray[3]) ? "" : (System.String)r.ItemArray[3];
                pa.product = System.DBNull.Value.Equals(r.ItemArray[4]) ? "" : (System.String)r.ItemArray[4];
                pa.spec = System.DBNull.Value.Equals(r.ItemArray[5]) ? "" : (System.String)r.ItemArray[5];
                
                barcode.Add(pa);
            }
            //-----PDF--------------------------------------------------------------------------------------------------
            //10*5
            var t_w=iTextSharp.text.Utilities.MillimetersToPoints(100);
            var t_h=iTextSharp.text.Utilities.MillimetersToPoints(50);
            var t_c=5;//邊界
            var doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(t_w, t_h), 5, 5, 0, 0);
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            if (barcode.Count == 0)
            {
                cb.SetColorFill(iTextSharp.text.BaseColor.RED);
                cb.BeginText();
                cb.SetFontAndSize(bfChinese, 30);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "無資料", 20, 20, 0);
                cb.EndText();
            }
            else
            {
                for (int i = 0; i < barcode.Count; i++)
                {
                    if (i != 0)
                    {
                        //Insert page
                        doc1.NewPage();
                    }
					//畫線
					cb.SetColorStroke(iTextSharp.text.BaseColor.BLACK);
                    cb.SetLineWidth(2);
                    
                    //畫框
                    cb.MoveTo(t_c, t_h-t_c);
                    cb.LineTo(t_w-t_c, t_h-t_c);
                    cb.Stroke();
					cb.MoveTo(t_c, t_c);
                    cb.LineTo(t_w-t_c, t_c);
                    cb.Stroke();
					cb.MoveTo(t_c, t_c);
                    cb.LineTo(t_c, t_h-t_c);
                    cb.Stroke();
					cb.MoveTo(t_w-t_c, t_c);
                    cb.LineTo(t_w-t_c, t_h-t_c);
                    cb.Stroke();
					
					cb.SetLineWidth(1);
					cb.MoveTo(t_c+60, t_c);
                    cb.LineTo(t_c+60, t_h-t_c);
                    cb.Stroke();
                    cb.MoveTo(t_c+110, t_h-t_c);
                    cb.LineTo(t_c+110, t_h-t_c-60);
                    cb.Stroke();
                    
                    cb.MoveTo(t_c+60, t_h-t_c-30);
                    cb.LineTo(t_w-t_c, t_h-t_c-30);
                    cb.Stroke();
                    cb.MoveTo(t_c, t_h-t_c-60);
                    cb.LineTo(t_w-t_c, t_h-t_c-60);
                    cb.Stroke();
                    cb.MoveTo(t_c, t_h-t_c-82);
                    cb.LineTo(t_w-t_c, t_h-t_c-82);
                    cb.Stroke();
                    cb.MoveTo(t_c, t_h-t_c-104);
                    cb.LineTo(t_w-t_c, t_h-t_c-104);
                    cb.Stroke();
					
                    //TEXT
                    cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
                    cb.BeginText();
                    cb.SetFontAndSize(bfChinese, 14);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "客　戶", t_c+60+3, t_h-t_c-30+10, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "版　別", t_c+60+3, t_h-t_c-60+10, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "料/單號", t_c+5, t_h-t_c-82+5, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "品　名", t_c+8, t_h-t_c-104+5, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "規　格", t_c+8, t_c+9, 0);
                    
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).comp, 10, 28, 0);
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).version, 10, 28, 0);
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).productno, 10, 28, 0);
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).product, 10, 28, 0);
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).spec, 10, 28, 0);
                    
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).comp, t_c+110+3, t_h-t_c-30+10, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).version, t_c+110+3, t_h-t_c-60+10, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).productno, t_c+60+3, t_h-t_c-82+5, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).product, t_c+60+3, t_h-t_c-104+5, 0);
                    
                    var t_spec=((Para)barcode[i]).spec;
                    
                    if(System.Text.Encoding.Default.GetBytes(t_spec).Length>25){
                    	cb.SetFontAndSize(bfChinese, 12);
                    	var t_n=t_spec.Length;
                    	for(var n=0;n<t_spec.Length;n++){
                    		if(System.Text.Encoding.Default.GetBytes(t_spec.Substring(0,n)).Length > 30){
                    			t_n=n;
                    			break;
                    		}
                    	}
                    	
                    	cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, t_spec.Substring(0,t_n), t_c+60+3, t_c+9+7, 0);
                    	cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, t_spec.Substring(t_n,(t_spec.Length-t_n)), t_c+60+3, t_c+4, 0);
                    }else{
                    	cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, t_spec, t_c+60+3, t_c+9, 0);
                    }
                    
                    cb.SetFontAndSize(bfChinese, 11);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[i]).noa, t_c+193, t_h-t_c-82+3, 0);
                    
                    cb.EndText();
                    
                    //QRCODE
                    System.Net.WebClient wc = new System.Net.WebClient();
					byte[] bytes = wc.DownloadData("https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl="+((Para)barcode[i]).productno+"&chld=H|0");
					System.IO.MemoryStream ms = new System.IO.MemoryStream(bytes);
                    iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(ms.ToArray());
                    img.ScalePercent(54f);
                    img.SetAbsolutePosition(t_c+2, t_h-t_c-58);
                    doc1.Add(img);
                }
            }
            doc1.Close();
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=barcode96.pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }
    </script>
