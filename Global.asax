<%@ Application Language="AVR" %>

<script runat="server">

	BegSr Application_Start
		DclSrParm sender Type(*Object)
		DclSrParm e Type(EventArgs)

		// Code that runs on application startup

	EndSr

	BegSr Application_End
		DclSrParm sender Type(*Object)
		DclSrParm e Type(EventArgs)

		//  Code that runs on application shutdown

	EndSr
        
	BegSr Application_Error
		DclSrParm sender Type(*Object)
		DclSrParm e Type(EventArgs)

		// Code that runs when an unhandled error occurs
        DclFld Error Type(System.Exception)
        DclFld HttpStatusCode Type(*Integer4) 
		DclFld PERSIST_CONTEXT Type(*Boolean) Inz(*True)

        Error = Server.GetLastError()
        Server.ClearError()

        If Error *Is HttpException
            HttpStatusCode = (Error *As HttpException).GetHttpCode()
            If (HttpStatusCode = 404)
                Server.TransferRequest('/404.aspx', PERSIST_CONTEXT)
            EndIf 
        EndIf 

        If Error *Is System.Web.HttpUnhandledException
            Session['LastError'] = Error
            Server.TransferRequest('/Error.aspx', PERSIST_CONTEXT)
        EndIf 
	EndSr

	BegSr Session_Start
		DclSrParm sender Type(*Object)
		DclSrParm e Type(EventArgs)

		// Code that runs when a new session is started

	EndSr

	BegSr Session_End
		DclSrParm sender Type(*Object)
		DclSrParm e Type(EventArgs)

		// Code that runs when a session ends. 
		// Note: The Session_End event is raised only when the sessionstate mode
		// is set to InProc in the Web.config file. If session mode is set to StateServer 
		// or SQLServer, the event is not raised.

	EndSr

       
</script>
