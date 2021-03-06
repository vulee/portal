<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.msf.form.data.FormType"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>MSF| Choose Form</title>
    </head>
    <%@include file="./welcome.jsp"%>
    <center>
        <%@include file="./bigger.jsp"%>
        <%
        // Get FormTypes enum
        FormType[] formTypes = FormType.values();
        
        // Create form map with key:{form_name}, value:{id}
        Map<String, String> formMap = new HashMap<String, String>();
        for(int i = 0; i < formTypes.length; i++){
            formMap.put(formTypes[i].getLabel(), String.valueOf(formTypes[i].getValue()));
        }
        
        boolean isResource = false;
        %>
        <table>
        <%
        
        String realPath = getServletContext().getRealPath("/");
        String dirFtpMsf = realPath.replace("MSFForm", "ftpmsf");
        
        File folder = new File(dirFtpMsf);
        File[] listOfFolders = folder.listFiles();
        
        for(int i = 0; i < listOfFolders.length; i++){
        	
        	File currentFolder = listOfFolders[i];
        	if (currentFolder.getName().compareToIgnoreCase("logs") == 0)
        		continue;           	
        	
            String folderName = currentFolder.getName();        	
            if(currentFolder.isDirectory()){
                if(!isResource){
        %>
                <tr>
                    <td>
                        <u><strong>List of existing Java Forms for modifying</strong></u>
                    </td>
                </tr>
        <%
                }
        %>
                <tr>
                    <td><%=folderName%></td>
        <%
                // Check resources folder existed in {folderName}
                File dirResources = new File(dirFtpMsf + folderName + "/resources");
                if(!dirResources.exists()){
        %>
                    <td>
                        <span>Resource not found</span>
                    </td>
        <%
                }else{
                    // Get form name, ex: NUT_LB => NUT
                    String formName = folderName.split("_")[0];
                    if(formMap.containsKey(formName)){
                        String formNumber = formMap.get(formName);
        %>
                    <td>
                        <form action="CreateGeneral" method="post">
                            <input type="submit" value="Edit"/>
                            <input type="hidden" name="selectForm" value="f<%=formNumber%>">
                            <input type="hidden" name="f<%=formNumber%>" value="<%=formName%>">
                            <input type="hidden" name="dirResources" value="<%=dirFtpMsf + folderName + "/resources/"%>">
                        </form>
                    <td>
                    <td>
                        <form action="DeleteResource" method="post" style="display: inline-block;">
                            <input type="submit" value="Delete"/>
                            <input type="hidden" id="delete_form" name="deleteForm" value="<%=dirFtpMsf + folderName + "/resources"%>"/>
                        </form>
                    </td>
        <%
                    }
                }
        %>
                </tr>
        <%
                isResource = true;
            }
        }
        %>
        </table>
        <%
        if(!isResource){
        %>
            <h2>Resource not found</h2>
        <%
        }
        %>
        <a href="./dataStorage.jsp">
            <input type="button" value="Back"/>
        </a>
    </center>
    <%@include file="./footer.jsp"%>
</html>
