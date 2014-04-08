<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
    
%>
<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>' onclick="setSaveButton();" onkeyup="setSaveButton();">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>

    <input type="hidden" name="subClass" value="PSYCHO"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_RAS" property="itemId"/>]>.value" value="medwan.common.false"/>

<script>
  function setTrue(itemType){
    var fieldName;
    fieldName = "currentTransactionVO.items.<ItemVO[hashCode="+itemType+"]>.value";
    document.getElementsByName(fieldName)[0].value = "medwan.common.true";
  }

  function setFalse(itemType){
    var fieldName;
    fieldName = "currentTransactionVO.items.<ItemVO[hashCode="+itemType+"]>.value";
    document.getElementsByName(fieldName)[0].value = "medwan.common.false";
  }
</script>

<table width="100%" class="list" cellspacing="0">
    <tr class="admin">
        <td><%=getTran("Web.Occup","medwan.healthrecord.psychosocial",sWebLanguage)%></td>
        <td align="right" width="20%">
            <%=getLabel("Web.Occup","medwan.common.nothing-to-mention",sWebLanguage,"psy-c1")%>&nbsp;<input name="psycho-ras" type="checkbox" id="psy-c1" value="medwan.common.true" onclick="if (this.checked == true) {hide('PSYCHO-details');setTrue('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_RAS" property="itemId"/>'); } else {show('PSYCHO-details');setFalse('<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_RAS" property="itemId"/>'); }">
        </td>
        <td align="right" width ="1%"><a href="#top" class="topbutton">&nbsp;</a></td>
    </tr>
    <tr id="PSYCHO-details" style="display:none" width="100%">
        <td colspan="4" width="100%">
            <table width="100%" cellspacing="1">
                <tr class="admin">
                    <td colspan="4"><%=getTran("Web.Occup","medwan.healthrecord.anamnese",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_ANAMNESIS_FATIGUE")%> type="checkbox" id="psy-c2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_ANAMNESIS_FATIGUE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_ANAMNESIS_FATIGUE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.fatigue",sWebLanguage,"psy-c2")%></td>
                    <td class="admin2" colspan="3"><input <%=setRightClick("ITEM_TYPE_PSYCHO_ANAMNESIS_STRESSED")%> type="checkbox" id="psy-c3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_ANAMNESIS_STRESSED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_ANAMNESIS_STRESSED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.stressed",sWebLanguage,"psy-c3")%></td>
                </tr>
                <tr class="admin">
                    <td colspan="4"><%=getTran("Web.Occup","medwan.healthrecord.diagnose",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_DEPRESSION")%> type="checkbox" id="psy-c4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_DEPRESSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_DEPRESSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.depression",sWebLanguage,"psy-c4")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_BURN_OUT")%> type="checkbox" id="psy-c5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_BURN_OUT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_BURN_OUT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.burn-out",sWebLanguage,"psy-c5")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_GENERAL_STRESS")%> type="checkbox" id="psy-c6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_GENERAL_STRESS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_GENERAL_STRESS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.general-stress",sWebLanguage,"psy-c6")%></td>
                    <td class="admin2" width="25%"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_MOBBING")%> type="checkbox" id="psy-c7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_MOBBING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_MOBBING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.mobbing",sWebLanguage,"psy-c7")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSISPHYSICAL_VIOLENCE")%> type="checkbox" id="psy-c8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSISPHYSICAL_VIOLENCE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSISPHYSICAL_VIOLENCE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.physical-violence",sWebLanguage,"psy-c8")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_SEXUAL_INTIMIDATION")%> type="checkbox" id="psy-c9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_SEXUAL_INTIMIDATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_SEXUAL_INTIMIDATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.sexual-intimidation",sWebLanguage,"psy-c9")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_ALCOHOL")%> type="checkbox" id="psy-c10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_ALCOHOL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_ALCOHOL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.alcohol",sWebLanguage,"psy-c10")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_DRUGS")%> type="checkbox" id="psy-c11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_DRUGS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_DRUGS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.drugs",sWebLanguage,"psy-c11")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_SLEEP_DISORDER")%> type="checkbox" id="psy-c12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_SLEEP_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_SLEEP_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.sleep-disorder",sWebLanguage,"psy-c12")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_PSYCHO_PHARMACA")%> type="checkbox" id="psy-c13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_PSYCHO_PHARMACA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_PSYCHO_PHARMACA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.psychopharmaca",sWebLanguage,"psy-c13")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_HYPERVENTILATION")%> type="checkbox" id="psy-c14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_HYPERVENTILATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_HYPERVENTILATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.hyperventilation",sWebLanguage,"psy-c14")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_FEAR_NEUROSIS")%> type="checkbox" id="psy-c15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_FEAR_NEUROSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_FEAR_NEUROSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.fear-neurosis",sWebLanguage,"psy-c15")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_SUICIDAL_TENDENCY")%> type="checkbox" id="psy-c16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_SUICIDAL_TENDENCY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_SUICIDAL_TENDENCY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.suicidal-tendency",sWebLanguage,"psy-c16")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_NERVOUSNESS")%> type="checkbox" id="psy-c17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_NERVOUSNESS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_NERVOUSNESS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.nervousness",sWebLanguage,"psy-c17")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_MANIC_DEPRESSION")%> type="checkbox" id="psy-c18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_MANIC_DEPRESSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_MANIC_DEPRESSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.manic-depression",sWebLanguage,"psy-c18")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_ADAPTATION_DISORDER")%> type="checkbox" id="psy-c19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_ADAPTATION_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_ADAPTATION_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.adaptation-disorder",sWebLanguage,"psy-c19")%></td>
                </tr>
                <tr>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_TICS")%> type="checkbox" id="psy-c20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_TICS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_TICS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.tics",sWebLanguage,"psy-c20")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_PSYCHO_SOMATIC_DISORDER")%> type="checkbox" id="psy-c21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_PSYCHO_SOMATIC_DISORDER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_PSYCHO_SOMATIC_DISORDER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.psychosomatic-disorders",sWebLanguage,"psy-c21")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_POST_PARTUM_DEPRESSION")%> type="checkbox" id="psy-c22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_POST_PARTUM_DEPRESSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_POST_PARTUM_DEPRESSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.post-partum-depression",sWebLanguage,"psy-c22")%></td>
                    <td class="admin2"><input <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_ANOREXIA_NERVOSA")%> type="checkbox" id="psy-c23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_ANOREXIA_NERVOSA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_ANOREXIA_NERVOSA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel("Web.Occup","medwan.healthrecord.psycho.anorexia-nervosa",sWebLanguage,"psy-c23")%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran("Web.Occup","medwan.common.remark",sWebLanguage)%></td>
                    <td class="admin2" colspan="3">
                        <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick("ITEM_TYPE_PSYCHO_DIAGNOSIS_OTHER")%> class="text" rows="2" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PSYCHO_DIAGNOSIS_OTHER" property="value"/></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<%-- BUTTONS --%>
<p align="right">
    <INPUT class="button" type="button" name="saveButton" onClick="doSubmit();" value="<%=getTran("Web.Occup","medwan.common.record",sWebLanguage)%>">
    <INPUT class="button" type="button" value="<%=getTran("Web","Back",sWebLanguage)%>" onclick="if (checkSaveButton('<%=sCONTEXTPATH%>','<%=getTran("Web.Occup","medwan.common.buttonquestion",sWebLanguage)%>')){window.location.href='<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType=<bean:write name="transaction" scope="page" property="transactionType"/>&be.mxs.healthrecord.transaction_id=currentTransaction&ts=<%=getTs()%>'}">
    <%=writeResetButton("transactionForm",sWebLanguage)%>
</p>

<script>
  function doSubmit(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
    %>
  }

  document.getElementsByName('psycho-ras')[0].onclick();
</script>

</form>
<%=writeJSButtons("transactionForm", "document.getElementsByName('save')[0]")%>