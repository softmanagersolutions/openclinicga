package be.mxs.common.util.pdf.general;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.pdf.PDFBasic;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.dpms.medwan.webapp.wo.common.system.SessionContainerWO;
import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import java.util.Date;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.awt.*;
import java.text.SimpleDateFormat;
import net.admin.AdminPerson;
import net.admin.User;
import javax.servlet.http.HttpServletRequest;


/**
 * User: Frank
 * Date: 1-mrt-2005
 */
//##################################################################################################
// Contains code used by most of the specific examination classes.
//##################################################################################################
public abstract class PDFGeneralBasic extends PDFBasic {

    // declarations
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    protected final int minNumberOfItems = 2;
    

    //--- GET HEADER TABLE -------------------------------------------------------------------------
    protected PdfPTable getHeaderTable(TransactionVO transactionVO){
        PdfPTable headerTable = new PdfPTable(10);
        headerTable.setWidthPercentage(100);

        try {
            doc.add(new Paragraph(" "));

            // transaction date
            cell = new PdfPCell(new Paragraph(dateFormat.format(transactionVO.getUpdateTime()),FontFactory.getFont(FontFactory.HELVETICA,8,Font.ITALIC)));
            cell.setColspan(1);
            cell.setBorder(Cell.BOX);
            cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cell.setBackgroundColor(Color.LIGHT_GRAY);
            headerTable.addCell(cell);

            // transaction type
            cell = new PdfPCell(new Paragraph(getTran("Web.Occup",transactionVO.getTransactionType()).toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,8,Font.ITALIC)));
            cell.setColspan(5);
            cell.setBorder(Cell.BOX);
            cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cell.setBackgroundColor(Color.LIGHT_GRAY);
            headerTable.addCell(cell);

            // transaction context
            ItemVO item = transactionVO.getItem(IConstants_PREFIX+"ITEM_TYPE_CONTEXT_CONTEXT");
            cell = new PdfPCell(new Paragraph(item!=null?getTran("Web.Occup",item.getValue()):"",FontFactory.getFont(FontFactory.HELVETICA,8,Font.ITALIC)));
            cell.setColspan(4);
            cell.setBorder(Cell.BOX);
            cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cell.setBackgroundColor(Color.LIGHT_GRAY);
            headerTable.addCell(cell);

            // new row : name of user who registered the transaction
            cell = new PdfPCell(new Paragraph(getTran("web.occup","medwan.common.user").toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
            cell.setColspan(4);
            cell.setBorder(Cell.BOX);
            cell.setVerticalAlignment(Cell.ALIGN_LEFT);
            headerTable.addCell(cell);

            User registeringUser = new User();
            registeringUser.initialize(transactionVO.user.getUserId().intValue());
            String username = registeringUser.person.lastname+" "+registeringUser.person.firstname;
            cell = new PdfPCell(new Paragraph(username,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
            cell.setColspan(6);
            cell.setBorder(Cell.BOX);
            cell.setVerticalAlignment(Cell.ALIGN_LEFT);
            headerTable.addCell(cell);
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return headerTable;
    }


    //*** ROWS *************************************************************************************

    //--- ADD ITEM ROW -----------------------------------------------------------------------------
    protected void addItemRow(PdfPTable table, String itemName, String itemValue){
        table.addCell(createItemNameCell(itemName));
        table.addCell(createValueCell(itemValue));
    }

    //--- ADD BLANK ROW ----------------------------------------------------------------------------
    protected void addBlankRow(int height){
        try{
            PdfPTable table = new PdfPTable(1);
            table.setTotalWidth(100);
            cell = new PdfPCell(new Phrase());
            cell.setBorder(Cell.NO_BORDER);
            cell.setPaddingTop(height); //
            table.addCell(cell);
            doc.add(table);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    protected void addBlankRow(){
        addBlankRow(5);
    }


    //*** CELLS ************************************************************************************

    //--- EMPTY CELL -------------------------------------------------------------------------------
    protected PdfPCell emptyCell(int colspan){
        cell = emptyCell();
        cell.setColspan(colspan);

        return cell;
    }

    protected PdfPCell emptyCell(){
        cell = new PdfPCell();
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);

        return cell;
    }

    //--- CREATE CELL ------------------------------------------------------------------------------
    protected PdfPCell createCell(PdfPCell childCell, int colspan, int alignment, int border){
        childCell.setColspan(colspan);
        childCell.setHorizontalAlignment(alignment);
        childCell.setBorder(border);
        childCell.setBorderColor(innerBorderColor);
        childCell.setVerticalAlignment(Cell.TOP);

        return childCell;
    }

    //--- CREATE CONTENT CELL ----------------------------------------------------------------------
    protected PdfPCell createContentCell(PdfPTable contentTable){
        cell = new PdfPCell(contentTable);
        cell.setPadding(3);
        cell.setBorder(Cell.NO_BORDER);
        cell.setVerticalAlignment(Cell.TOP);
        cell.setHorizontalAlignment(Cell.ALIGN_CENTER);

        return cell;
    }

    //--- CREATE ITEMNAME CELL ---------------------------------------------------------------------
    protected PdfPCell createItemNameCell(String itemName, int colspan){
        cell = new PdfPCell(new Paragraph(itemName.toUpperCase(),FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(colspan);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Cell.ALIGN_LEFT);

        return cell;
    }

    protected PdfPCell createItemNameCell(String itemName){
        return createItemNameCell(itemName,2);
    }

    //--- CREATE HEADER CELL -----------------------------------------------------------------------
    protected PdfPCell createHeaderCell(String msg, int colspan){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,7,Font.ITALIC)));
        cell.setColspan(colspan);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cell.setBackgroundColor(BGCOLOR_LIGHT);

        return cell;
    }

    //--- CREATE TITLE CELL ------------------------------------------------------------------------
    protected PdfPCell createTitleCell(String msg, int colspan){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLDITALIC)));
        cell.setColspan(colspan);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_TOP);
        cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cell.setBackgroundColor(new Color(220,220,220)); // grey

        return cell;
    }

    //--- CREATE VALUE CELL ------------------------------------------------------------------------
    protected PdfPCell createValueCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(colspan);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_TOP);
        cell.setHorizontalAlignment(Cell.ALIGN_LEFT);

        return cell;
    }

    protected PdfPCell createValueCell(String value){
        return createValueCell(value,3);
    }

    //--- CREATE INVISIBLE CELL -------------------------------------------------------------------
    protected PdfPCell createInvisibleCell(){
        return createInvisibleCell(1);
    }

    protected PdfPCell createInvisibleCell(int colspan){
        cell = new PdfPCell();
        cell.setColspan(colspan);
        cell.setBorder(Cell.NO_BORDER);
        cell.setVerticalAlignment(Cell.ALIGN_TOP);
        cell.setHorizontalAlignment(Cell.ALIGN_LEFT);

        return cell;
    }

    //--- CREATE BORDERLESS CELL -------------------------------------------------------------------
    protected PdfPCell createBorderlessCell(String value, int height, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setPaddingTop(height); //
        cell.setColspan(colspan);
        cell.setBorder(Cell.BOX); //
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_TOP);
        cell.setHorizontalAlignment(Cell.ALIGN_LEFT);

        return cell;
    }

    protected PdfPCell createBorderlessCell(String value, int colspan){
        return createBorderlessCell(value,3,colspan);
    }

    protected PdfPCell createBorderlessCell(int colspan){
        cell = new PdfPCell();
        cell.setColspan(colspan);
        cell.setBorder(Cell.TOP+Cell.BOTTOM); //
        cell.setBorderColor(innerBorderColor);

        return cell;
    }


    //*** COLOR CELLS *****************************************************************************

    //--- CREATE GREEN CELL -----------------------------------------------------------------------
    protected PdfPCell createGreenCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(1);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cell.setBackgroundColor(new Color(60,220,60)); // light green

        return cell;
    }

    protected PdfPCell createGreenCell(String value){
        return createGreenCell(value,1);
    }

    //--- CREATE RED CELL -------------------------------------------------------------------------
    protected PdfPCell createRedCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(1);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cell.setBackgroundColor(new Color(230,50,50)); // light red

        return cell;
    }

    protected PdfPCell createRedCell(String value){
        return createRedCell(value,1);
    }

    //--- CREATE GREY CELL ------------------------------------------------------------------------
    protected PdfPCell createGreyCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(1);
        cell.setBorder(Cell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cell.setBackgroundColor(new Color(245,245,245)); // light gray

        return cell;
    }

    protected PdfPCell createGreyCell(String value){
        return createGreyCell(value,1);
    }

    //--- GET PROVIDER NAME FROM CODE -------------------------------------------------------------
    // used in : PDFLabRequest, PDFMedicalImagingRequest, PDFOtherRequests
    //---------------------------------------------------------------------------------------------
    protected String getProviderNameFromCode(String code) throws SQLException {
        String name = "";

        // compose select
        String lowerCode = getConfigParam("lowerCompare","code");
        String sQuery = "SELECT name FROM Providers WHERE "+lowerCode+" = ?";
    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        PreparedStatement ps = ad_conn.prepareStatement(sQuery);
        ps.setString(1,code);
        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            name = rs.getString("name");
        }

        rs.close();
        ps.close();
        ad_conn.close();

        return name;
    }

    //--- GET ITEM TYPE ---------------------------------------------------------------------------
    protected String getItemSeriesValue(String sItemType){
        return getItemSeriesValue(transactionVO,sItemType);
    }

    protected String getItemSeriesValue(TransactionVO transactionVO, String sItemType){
        StringBuffer sBuffer = new StringBuffer();

        // search for item with number-less name (the first item)
        sBuffer.append(checkString(getItemValue(transactionVO,sItemType)));

        // search for items with a number at the end of the name (proceding items)
        String itemValue;
        for(int i=1; i<=15; i++){
            itemValue = checkString(getItemValue(transactionVO,sItemType+i));
            if(itemValue.length()==0) break;
            sBuffer.append(itemValue);
        }

        return sBuffer.toString();
    }
    
    //--- PRINT (1) -------------------------------------------------------------------------------
    public void print(Document doc, SessionContainerWO sessionContainerWO, TransactionVO transactionVO,
                      AdminPerson adminPerson, HttpServletRequest req, String sProject, Date dateFrom,
                      Date dateTo, String sPrintLanguage, Integer partsOfTransactionToPrint){

        this.doc = doc;
        this.sessionContainerWO = sessionContainerWO;
        this.transactionVO = transactionVO;
        this.sPrintLanguage = sPrintLanguage;
        this.patient = adminPerson;
        this.req = req;
        this.sProject = sProject;
        this.dateFrom = dateFrom;
        this.dateTo = dateTo;

        // 0 = nothing, 1 = header, 2 = header + body
        if(partsOfTransactionToPrint.intValue() > 0){
            // put header and body in one table
            tranTable = new PdfPTable(1);
            tranTable.addCell(createCell(new PdfPCell(getHeaderTable(transactionVO)),1,Cell.ALIGN_CENTER,Cell.NO_BORDER));

            if(partsOfTransactionToPrint.intValue() > 1){
                addContent(); // contains addTableToDoc
            }
            else{
                // only header, no content
                addTransactionToDoc();
            }
        }
    }

    //--- PRINT (2) (overloader) ------------------------------------------------------------------
    public void print(Document doc, SessionContainerWO sessionContainerWO, TransactionVO transactionVO,
                      AdminPerson adminPerson, HttpServletRequest req, String sProject, String sPrintLanguage,
                      Integer partsOfTransactionToPrint){

        print(doc, sessionContainerWO, transactionVO, adminPerson, req, sProject, null, null,
              sPrintLanguage, partsOfTransactionToPrint);
    }

    //--- ABSTRACT --------------------------------------------------------------------------------
    protected abstract void addContent();

}