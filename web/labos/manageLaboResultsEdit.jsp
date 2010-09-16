<%@ page import="be.openclinic.medical.RequestedLabAnalysis,java.util.*,be.openclinic.medical.LabRequest" %>
<%@ page import="be.openclinic.medical.LabAnalysis" %>
<%@include file="/includes/validateUser.jsp" %>
<%=checkPermission("labos.openpatientlaboresults", "select", activeUser)%><%=checkPermission("labos.biologicvalidationbyrequest", "select", activeUser)%><%!
    public class LabRow {
        int type;
        String tag;
        public LabRow(int type, String tag) {
            this.type = type;
            this.tag = tag;
        }
    }
    public String getComplexResult(String id, Map map, String sWebLanguage) {
        String sReturn = "<input type='hidden' name='result." + id + "' />";
        sReturn += "<input type='hidden' id='resultAntibio." + id + ".germ1' name='resultAntibio." + id + ".germ1' value='" + checkString((String) map.get("germ1")) + "'/>";
        sReturn += "<input type='hidden' id='resultAntibio." + id + ".germ2' name='resultAntibio." + id + ".germ2' value='" + checkString((String) map.get("germ2")) + "' />";
        sReturn += "<input type='hidden' id='resultAntibio." + id + ".germ3' name='resultAntibio." + id + ".germ3' value='" + checkString((String) map.get("germ3")) + "' />";
        sReturn += "<input type='hidden' id='resultAntibio." + id + ".antibio1' name='resultAntibio." + id + ".ANTIBIOGRAMME1' value='" + checkString((String) map.get("ANTIBIOGRAMME1")) + "' />";
        sReturn += "<input type='hidden' id='resultAntibio." + id + ".antibio2' name='resultAntibio." + id + ".ANTIBIOGRAMME2' value='" + checkString((String) map.get("ANTIBIOGRAMME2")) + "' />";
        sReturn += "<input type='hidden' id='resultAntibio." + id + ".antibio3' name='resultAntibio." + id + ".ANTIBIOGRAMME3' value='" + checkString((String) map.get("ANTIBIOGRAMME3")) + "' />";
        sReturn += "<a class='link' style='padding-left:2px' href='javascript:void(0)' onclick='openComplexResult(\"" + id + "\")'>" + getTranNoLink("labanalysis", "openAntibiogrameresult", sWebLanguage) + "</a>";
        sReturn += " "+getTran("web","resultcomplete",sWebLanguage)+" <input type='checkbox' name='validateAntibio."+id+"'/>";
        return sReturn;
    }
%>
<%
    boolean bSaved = false;
    if (request.getParameter("submit") != null) {
        bSaved = true;
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String name = (String) e.nextElement();
            if (name.startsWith("result.")) {
                String[] v = name.split("\\.");
                String value = request.getParameter(name);
                RequestedLabAnalysis.updateValue(Integer.parseInt(v[1]), Integer.parseInt(v[2]), v[3], value);
                RequestedLabAnalysis.setFinalValidation(Integer.parseInt(v[1]), Integer.parseInt(v[2]), Integer.parseInt(activeUser.userid), "'"+v[3]+"'");
            } else if (name.startsWith("resultAntibio.")) {
                RequestedLabAnalysis.setAntibiogrammes(name, request.getParameter(name), activeUser.userid);
            } else if (name.startsWith("validateAntibio.")) {
                String[] v = name.split("\\.");
                RequestedLabAnalysis.setForcedFinalValidation(Integer.parseInt(v[1]), Integer.parseInt(v[2]), Integer.parseInt(activeUser.userid), "'"+v[3]+"'");
            }
        }
    }
    SortedMap requestList = new TreeMap();
    Vector r = LabRequest.findUntreatedRequests(sWebLanguage, Integer.parseInt(activePatient.personid));
    for (int n = 0; n < r.size(); n++) {
        LabRequest labRequest = (LabRequest) r.elementAt(n);
        if (labRequest.getRequestdate() != null) {
            requestList.put(new SimpleDateFormat("yyyyMMddHHmmss").format(labRequest.getRequestdate()) + "." + labRequest.getServerid() + "." + labRequest.getTransactionid(), labRequest);
        }
    }
    SortedMap groups = new TreeMap();
    Iterator iterator = requestList.keySet().iterator();
    while (iterator.hasNext()) {
        LabRequest labRequest = (LabRequest) requestList.get(iterator.next());
        Enumeration enumeration = labRequest.getAnalyses().elements();
        while (enumeration.hasMoreElements()) {
            RequestedLabAnalysis requestedLabAnalysis = (RequestedLabAnalysis) enumeration.nextElement();
            if (groups.get(MedwanQuery.getInstance().getLabel("labanalysis.group", requestedLabAnalysis.getLabgroup(), sWebLanguage)) == null) {
                groups.put(MedwanQuery.getInstance().getLabel("labanalysis.group", requestedLabAnalysis.getLabgroup(), sWebLanguage), new Hashtable());
            }
            ((Hashtable) groups.get(MedwanQuery.getInstance().getLabel("labanalysis.group", requestedLabAnalysis.getLabgroup(), sWebLanguage))).put(requestedLabAnalysis.getAnalysisCode(), "1");
        }
    }%>
<%=writeTableHeader("Web", "openPatientLaboResults", sWebLanguage, " doBack();")%><form method='post' name='fastresults'>
    <table width="100%" cellspacing="3">
        <tr>
            <td/>
            <td width="1"/>
            <td><%=getTran("web", "analysis", sWebLanguage)%>
            </td>
            <%
                Iterator requestsIterator = requestList.keySet().iterator();
                while (requestsIterator.hasNext()) {
                    LabRequest labRequest = (LabRequest) requestList.get(requestsIterator.next());
                    out.print("<td>" + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(labRequest.getRequestdate()) + "&nbsp;&nbsp;&nbsp; &nbsp;<a href='javascript:showRequest(" + labRequest.getServerid() + "," + labRequest.getTransactionid() + ")'><b>" + labRequest.getTransactionid() + "</b></a></td>");
                }
            %>
        </tr>
        <%
            String abnormal = MedwanQuery.getInstance().getConfigString("abnormalModifiers", "*+*++*+++*-*--*---*h*hh*hhh*l*ll*lll*");
            boolean bEditable = activeUser.getAccessRight("labos.biologicvalidationbyrequest.edit");
            Iterator groupsIterator = groups.keySet().iterator();
            int i = 0;   // for colors
            while (groupsIterator.hasNext()) {
                i++;
                String groupname = (String) groupsIterator.next();
                Hashtable analysisList = (Hashtable) groups.get(groupname);
                out.print("<tr ><td  class='color color" + i + "' rowspan='" + analysisList.size() + "'><b>" + MedwanQuery.getInstance().getLabel("labanalysis.groups", groupname, sWebLanguage).toUpperCase() + "</b></td>");
                SortedSet sortedSet = new TreeSet();
                sortedSet.addAll(analysisList.keySet());
                Iterator analysisEnumeration = sortedSet.iterator();
                while (analysisEnumeration.hasNext()) {
                    String analysisCode = (String) analysisEnumeration.next();
                    String c = analysisCode;
                    String u = "";
                    LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(analysisCode);
                    if (analysis != null) {
                        c = analysis.getLabId() + "";
                        u = " (" + analysis.getUnit() + ")";
                    }
                    out.print("<td class='color color" + i + "'>" + analysisCode + "</td><td class='color color" + i + "' width='*'><b>" + MedwanQuery.getInstance().getLabel("labanalysis", c, sWebLanguage) + " " + u + "</b></td>");
                    requestsIterator = requestList.keySet().iterator();
                    while (requestsIterator.hasNext()) {
                        LabRequest labRequest = (LabRequest) requestList.get(requestsIterator.next());
                        RequestedLabAnalysis requestedLabAnalysis = (RequestedLabAnalysis) labRequest.getAnalyses().get(analysisCode);
                        // changed by emanuel@mxs.be
                        String result = "";
                        if(requestedLabAnalysis != null){
	                        if (!groupname.equalsIgnoreCase(getTran("labanalysis.group", "bacteriology", sWebLanguage))){
								if(bEditable){
									result="<input class='text' type='text' name='result." + labRequest.getServerid() + "." + labRequest.getTransactionid() + "." + requestedLabAnalysis.getAnalysisCode() + "' value='" + checkString(requestedLabAnalysis.getResultValue()) + "'/>" + u;
								} else {
									result=requestedLabAnalysis.getResultValue();
								}
	                        }
	                        else {
	                        	result = getComplexResult(labRequest.getServerid() + "." + labRequest.getTransactionid() + "." + requestedLabAnalysis.getAnalysisCode(), RequestedLabAnalysis.getAntibiogrammes(labRequest.getServerid() + "." + labRequest.getTransactionid() + "." + requestedLabAnalysis.getAnalysisCode()), sWebLanguage);                        	//result = getComplexResult(labRequest.getServerid() + "." + labRequest.getTransactionid() + "." + requestedLabAnalysis.getAnalysisCode(), RequestedLabAnalysis.getAntibiogrammes(labRequest.getServerid() + "." + labRequest.getTransactionid() + "." + requestedLabAnalysis.getAnalysisCode()), sWebLanguage);
	                        }
                        }
                        boolean bAbnormal = (result.length() > 0 && !result.equalsIgnoreCase("?") && abnormal.toLowerCase().indexOf("*" + checkString(requestedLabAnalysis.getResultModifier()).toLowerCase() + "*") > -1);
                        out.print("<td   class='color color" + i + "'>" + result + (bAbnormal ? " " + checkString(requestedLabAnalysis.getResultModifier().toUpperCase()) : "") + "</td>");
                    }
                    out.print("</tr>");
                }
            }
        %>
    </table>
    <p/>
    <p style="width:100%;text-align:center;">
        <input class="button" type="submit" name="submit" value="<%=getTran("web","save",sWebLanguage)%>"/>
    </p>
</form>
<script type="text/javascript">
    <%
        if(bSaved){
            out.write("closeModalbox('"+ getTranNoLink("web","saved",sWebLanguage)+"');");
        }
    %>
    function showRequest(serverid, transactionid) {
        window.open("<c:url value='/popup.jsp'/>?Page=labos/manageLabResult_view.jsp&ts=<%=getTs()%>&show." + serverid + "." + transactionid + "=1", "Popup" + new Date().getTime(), "toolbar=no, status=yes, scrollbars=yes, resizable=yes, width=800, height=600, menubar=no");
    }
    function doBack() {
        window.location.href = "<c:url value="/main.do"/>?Page=labos/index.jsp";
    }
    openComplexResult = function(id) {
        var params = "antibiogramuid=" + id + "&editable=<%=bEditable%>";
        var url = "<c:url value="/labos/ajax/getComplexResult.jsp" />?ts=" + new Date().getTime();
        Modalbox.show(url, {title:"<%=getTranNoLink("web","antibiogram",sWebLanguage)%>",params:params,width:600});
    }
    addObserversToAntibiogram = function(id) {
        $("germ1").value = $F("resultAntibio." + id + ".germ1");
        $("germ2").value = $F("resultAntibio." + id + ".germ2");
        $("germ3").value = $F("resultAntibio." + id + ".germ3");
        setCheckBoxValues(id, $F("resultAntibio." + id + ".antibio1").split(","), 1);
        setCheckBoxValues(id, $F("resultAntibio." + id + ".antibio2").split(","), 2);
        setCheckBoxValues(id, $F("resultAntibio." + id + ".antibio3").split(","), 3);
        $('antibiogramtable').getElementsBySelector('[type="radio"]').each(function(e) {
            e.parentNode.observe('click', function(event) {
                //alert(Event.element(event));
                var elem = Event.element(event);
                if (elem.tagName == "TD") {
                    if (elem.firstChild.checked) {
                        elem.firstChild.checked = false;
                    } else {
                        elem.firstChild.checked = true;
                        new Effect.Highlight(elem, { startcolor: '#FFE7DA'});
                    }
                } else {
                    new Effect.Highlight(elem.parentNode, { startcolor: '#FFE7DA'});
                }
            });
        });

    }
    setCheckBoxValues = function(id, tab, nb) {
        tab.each(function(anti) {
            if (anti.length > 0) {
                var tAnti = anti.split("=");
                try {
                    $(tAnti[0] + "_radio_" + nb + "_" + tAnti[1]).checked = true;
                } catch(e) {
                    alert(tAnti[0] + "_radio_" + nb + "_" + tAnti[1]);
                }
            }
        });
    }
    setAntibiogram = function (id) {
        var s = "";
        $("resultAntibio." + id + ".germ1").value = $F("germ1");
        $("resultAntibio." + id + ".germ2").value = $F("germ2");
        $("resultAntibio." + id + ".germ3").value = $F("germ3");
        $("resultAntibio." + id + ".antibio1").value = "";
        $("resultAntibio." + id + ".antibio2").value = "";
        $("resultAntibio." + id + ".antibio3").value = "";
        $('antibiogramtable').getElementsBySelector('[type="radio"]').each(function(e) {
            if (e.checked) {
                s += "\n" + e.name + " -  " + e.value;
                var tab = e.name.split("_");
                $("resultAntibio." + id + ".antibio" + tab[2]).value = $F("resultAntibio." + id + ".antibio" + tab[2]) + "," + tab[0] + "=" + e.value;
            }
        });
        Modalbox.hide();
    }
</script>