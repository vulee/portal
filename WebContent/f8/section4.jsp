<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <%

	String sectionTmp4 = session.getServletContext().getRealPath("/f8/Files_sections/");
	File dirSectionFiles4=new File(sectionTmp4);
	
	if (!dirSectionFiles4.exists()) {
		dirSectionFiles4.mkdirs();
		out.print("First time: need to copy the resources.");
	}else{
			String sectionPath1 = session.getServletContext().getRealPath("/f8/Files_sections/");
		 	String fileNameId="Section-opd_dressing_injections-TablesIds.txt";
		 	String fileNameTitle="Section-opd_dressing_injections-TablesLabels.txt";

		 	String strTitle="Dressing & injections";//read from encounterLabel.txt
		 	String xmlTitle="<msf_tableAGG_4>";
		 	String xmlRow="<msf_rowAGG_4>";
           	BufferedReader rdId = new BufferedReader(new FileReader(sectionPath1+ "/"+fileNameId));
          	BufferedReader rdTitle = new BufferedReader(new FileReader(sectionPath1+ "/"+fileNameTitle));
	        String lineTitle,lineId;
	        Hashtable<String,String> htTitle=new Hashtable<String,String>(); 
           // load dictionary
           String[] strSplit;
           while((lineTitle = rdTitle.readLine())!= null){
        	   if(lineTitle.trim().endsWith("en"))
        	   {
        		   strSplit=lineTitle.split("\t");
        		   if("".compareToIgnoreCase(strSplit[0].trim())!=0){
        		   htTitle.put(strSplit[0],strSplit[1]);
        		   if(strSplit[0].trim().endsWith("|Label")){
        			   htTitle.put(strSplit[0].substring(0,strSplit[0].trim().length()-6), strSplit[1]);
        		   }}
        	   }
           }
           rdTitle.close();
           StringBuilder sbTableId=new StringBuilder();
           while((lineId = rdId.readLine())!= null){
        	   if("".compareToIgnoreCase(lineId.trim())!=0)
      	   			sbTableId.append(lineId+"\n");
           }
           rdId.close();
%>
		<a  href="javascript:toggle('section4');">
			<h2><%=strTitle %></a>&nbsp;&nbsp;&nbsp;&nbsp;Select:&nbsp;<input type="checkbox" name="section4" value="1" checked><input type="hidden" name="section4" value="0"> 
			</h2> <div id="section4" style="display: none" href="javascript:toggle();">	
			<input type="hidden" name="fileSection4" value="<%=fileNameId %>"> 
<%           
           String[] sectionTable=sbTableId.toString().split("SectionSeparator\n");
%>
			<input type="hidden" name="TotalTableSection4" value="<%=sectionTable.length %>"> 
<%
           String sectionI;
           String[] iRow;
           String[] iCol;
           String strTitleTD=null;
           String[] strTmp=null;
           for(int i=0;i<sectionTable.length;i++){

        	   sectionI=sectionTable[i];
        	   iRow=sectionI.split("\n");
        	 //show table title
        	   %>
        	           	  <h3 style="color: green">+&emsp;<%=iRow[0].split("\t")[1]%>&emsp;&emsp;<input type="checkbox" name="<%=xmlTitle%>[<%=i%>]" value="<%=iRow[0]%>" checked><input type="hidden" name="<%=xmlTitle%>[<%=i%>]" value="0"></h3> 
        	   	   <table border="1">
        	   <%
        	   for(int j=1;j<iRow.length;j++)//no need the first row
        	   {
        		   if("".compareToIgnoreCase(iRow[j].trim())!=0){
%>
		<tr>
<%
			strTitleTD="";
			iCol=iRow[j].split("\t");
			for(int k=0;k<iCol.length-1;k++)
			   {
				   try{
					   if(htTitle.containsKey(iCol[k])){
							strTitleTD="<strong>"+htTitle.get(iCol[k]).toString()+"</strong>";
					   }
					   else{
						   strTmp=iCol[k].split("<COL>");
						   if(htTitle.containsKey(strTmp[1].trim()))
						   {
							   strTitleTD="<strong>"+htTitle.get(strTmp[1]).toString()+"</strong>";
						   }else
						   {	
							   
							   String[] strTmp2=strTmp[1].split("\\|");
						
							   //out.print("<br>string="+strTmp[1]+"<br>before |"+strTmp2[0].toString()+"<br>after |"+strTmp2[1].toString());
							   if(strTmp2.length>1)
							   {
								   if(htTitle.containsKey(strTmp2[0]))
										strTitleTD="<i>"+htTitle.get(strTmp2[0]).toString()+"|"+strTmp2[1]+"</i>";
							   }else
								   strTitleTD="<i>"+htTitle.get(strTmp2[0]).toString()+"</i>";
						   }
					   }
				   }catch(Exception e){
					   e.printStackTrace();
					   strTitleTD="";
				   }
%>
					<td><%=strTitleTD%></td>		
<%        			   
        		   }
%>
<td><input type="checkbox" name="<%=xmlRow%>[<%=i%>][<%=j%>]" value="<%=iRow[j]%>" checked><input type="hidden" name="<%=xmlRow%>[<%=i%>][<%=j%>]" value="0"></td>
		</tr>
<%        		   
        	   }}
%>       	   
  		</table><br><br>        	   
<%        	   
           		
           }
%> 
			</div>
<%
	}
%>
