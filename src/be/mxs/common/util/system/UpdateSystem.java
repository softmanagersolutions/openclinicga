package be.mxs.common.util.system;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import net.admin.Label;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.system.TransactionItem;

public class UpdateSystem {

	public static void update(String basedir){
		updateDb();
		updateLabels(basedir);
		updateTransactionItems(basedir);
        String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "application.xml";
        SAXReader reader = new SAXReader(false);
        try{
	        Document document = reader.read(new URL(sDoc));
	        Element element = document.getRootElement().element("version");
	        int thisversion=Integer.parseInt(element.attribute("major").getValue())*1000000+Integer.parseInt(element.attribute("minor").getValue())*1000+Integer.parseInt(element.attribute("bug").getValue());
	        MedwanQuery.getInstance().setConfigString("updateVersion",thisversion+"");
        }
        catch(Exception e){
        	e.printStackTrace();
        }
	}
	
	public static void updateDb(){
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": start updatedb");
		try {
			String sDoc="";
			Connection loc_conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
			Connection sta_conn = MedwanQuery.getInstance().getStatsConnection();
			Connection lad_conn = MedwanQuery.getInstance().getLongAdminConnection();
			String sLocalDbType="?";
			try {
			    sLocalDbType = lad_conn.getMetaData().getDatabaseProductName();
			}
			catch(Exception e){
			    //e.printStackTrace();
			}

			boolean bInit=false;
			SAXReader reader = new SAXReader(false);
			sDoc = MedwanQuery.getInstance().getConfigString("templateSource","http://localhost/openclinic/_common/xml/")+"db.xml";
			org.dom4j.Document document = reader.read(new URL(sDoc));
			bInit=true;
			Iterator tables = document.getRootElement().elementIterator("table");

			Element table;
			String sMessage = "";
		    //if(Debug.enabled) Debug.println("1");
		    String sOwnServerId = MedwanQuery.getInstance().getConfigString("serverId");
		    Element versionColumn = null;
		    Connection connectionCheck = null;
		    PreparedStatement psCheck = null;
		    ResultSet rsCheck = null,rsCheck2=null;
		    Connection otherAdminConnection = null;
		    Connection otherOccupConnection = null;
		    Element model = document.getRootElement();
		    Element column, index, view, proc, exec, sql;
		    DatabaseMetaData databaseMetaData;
		    Hashtable adminTables=new Hashtable(),adminColumns=new Hashtable(),adminIndexes=new Hashtable(),openclinicTables=new Hashtable(),openclinicColumns=new Hashtable(),openclinicIndexes=new Hashtable(),statsTables=new Hashtable(),statsColumns=new Hashtable(),statsIndexes=new Hashtable();
		    Hashtable hTables=null,hColumns=null,hIndexes=null;
		    Iterator columns, indexes, indexcolumns, views, sqlIterator, procs, execs;
		    String sSelect, sVal, sQuery, sCountQuery, otherServerId, inSql, versioncompare, values, outSql, indexname;
		    Connection source, destination;
		    boolean inited, indexFound, bDoWork, bInited, bCreate;
		    PreparedStatement psSync;
		    ResultSet rsSync, rsCount;
		    PreparedStatement psCountSync, psSync2;
		    ResultSet rsCountSync, rsSync2;
		    Object maxVersion;
		    HashMap primaryKey, cols;
		    int counter, total, syncTotal, rowCounter, compareStatus;
		    Statement stDelete, stCount, st;
		    Integer nVal;
		    Vector params;

			System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": update tables");
			//First load databasemodels
			String tableName,columnName,indexName;
			databaseMetaData=lad_conn.getMetaData();
			rsCheck=databaseMetaData.getColumns(null, null, null, null);
			while(rsCheck.next()){
				tableName=rsCheck.getString("TABLE_NAME");
				columnName=rsCheck.getString("COLUMN_NAME");
				if(adminTables.get(tableName)==null){
					rsCheck2=databaseMetaData.getIndexInfo(null, null, tableName, false, true);
					while(rsCheck2.next()){
						indexName=rsCheck2.getString("INDEX_NAME");
						adminIndexes.put((tableName+"$"+indexName).toLowerCase(),"");
					}
					adminTables.put(tableName.toLowerCase(),"");
				}
				adminColumns.put((tableName+"$"+columnName).toLowerCase(),"");
			}
			
			databaseMetaData=loc_conn.getMetaData();
			rsCheck=databaseMetaData.getColumns(null, null, null, null);
			while(rsCheck.next()){
				tableName=rsCheck.getString("TABLE_NAME");
				columnName=rsCheck.getString("COLUMN_NAME");
				if(openclinicTables.get(tableName)==null){
					openclinicTables.put(tableName.toLowerCase(),"");
					rsCheck2=databaseMetaData.getIndexInfo(null, null, tableName, false, true);
					while(rsCheck2.next()){
						indexName=rsCheck2.getString("INDEX_NAME");
						openclinicIndexes.put((tableName+"$"+indexName).toLowerCase(),"");
					}
				}
				openclinicColumns.put((tableName+"$"+columnName).toLowerCase(),"");
			}

			databaseMetaData=sta_conn.getMetaData();
			rsCheck=databaseMetaData.getColumns(null, null, null, null);
			while(rsCheck.next()){
				tableName=rsCheck.getString("TABLE_NAME");
				columnName=rsCheck.getString("COLUMN_NAME");
				if(statsTables.get(tableName)==null){
					statsTables.put(tableName.toLowerCase(),"");
					rsCheck2=databaseMetaData.getIndexInfo(null, null, tableName, false, true);
					while(rsCheck2.next()){
						indexName=rsCheck2.getString("INDEX_NAME");
						statsIndexes.put((tableName+"$"+indexName).toLowerCase(),"");
					}
				}
				statsColumns.put((tableName+"$"+columnName).toLowerCase(),"");
			}
			
		    tables = model.elementIterator("table");
		    while (tables.hasNext()) {
		        table = (Element) tables.next();
		        if (table.attribute("db").getValue().equalsIgnoreCase("ocadmin")) {
		            connectionCheck = lad_conn;
		            hTables=adminTables;
		            hColumns=adminColumns;
		            hIndexes=adminIndexes;
		        } else if (table.attribute("db").getValue().equalsIgnoreCase("openclinic")) {
		            connectionCheck = loc_conn;
		            hTables=openclinicTables;
		            hColumns=openclinicColumns;
		            hIndexes=openclinicIndexes;
		        } else if (table.attribute("db").getValue().equalsIgnoreCase("stats")) {
		            connectionCheck = sta_conn;
		            hTables=statsTables;
		            hColumns=statsColumns;
		            hIndexes=statsIndexes;
		        }

		        boolean tableExists=hTables.get(table.attribute("name").getValue().toLowerCase())!=null;

		        if (tableExists) {
		            //verify the table columns
		            versionColumn = null;
		            columns = table.element("columns").elementIterator("column");
		            while (columns.hasNext()) {
		                try {
		                    column = (Element) columns.next();
		                    if (column.attribute("version") != null && column.attribute("version").getValue().equalsIgnoreCase("1")) {
		                        versionColumn = column;
		                    }
		                    rsCheck = databaseMetaData.getColumns(null, null, table.attribute("name").getValue(), column.attribute("name").getValue());
		                    boolean columnExists=hColumns.get(table.attribute("name").getValue().toLowerCase()+"$"+column.attribute("name").getValue().toLowerCase())!=null;
		                    if (!columnExists) {
		                        sSelect = "alter table " + table.attribute("name").getValue() + " add " + column.attribute("name").getValue() + " ";
		                        if (column.attribute("dbtype").getValue().equalsIgnoreCase("char") || column.attribute("dbtype").getValue().equalsIgnoreCase("varchar")) {
		                            sSelect += column.attribute("dbtype").getValue() + "(" + column.attribute("size").getValue() + ")";
		                        } else {
		                            sSelect += column.attribute("dbtype").getValue();
		                        }
		                        sSelect += " null";
		                        psCheck = connectionCheck.prepareStatement(sSelect);
		                        psCheck.execute();
		                        psCheck.close();
		                    }
		                }
		                catch (Exception e) {
		                	e.printStackTrace();
		                }
		            }
		        } else {
		               //create the table
		               sSelect = "create table " + table.attribute("name").getValue() + "(";
		               columns = table.element("columns").elementIterator("column");
		               inited = false;
		               while (columns.hasNext()) {
		                   column = (Element) columns.next();
		                   if (inited) {
		                       sSelect += ",";
		                   } else {
		                       inited = true;
		                   }

		                   sSelect += column.attribute("name").getValue() + " ";

		                   if (column.attribute("dbtype").getValue().equalsIgnoreCase("char") || column.attribute("dbtype").getValue().equalsIgnoreCase("varchar")) {
		                       sSelect += column.attribute("dbtype").getValue() + "(" + column.attribute("size").getValue() + ")";
		                   } else {
		                       sSelect += column.attribute("dbtype").getValue();
		                   }

		                   if (column.attribute("nulls") != null && column.attribute("nulls").getValue().equalsIgnoreCase("0")) {
		                       sSelect += " not null";
		                   } else {
		                       sSelect += " null";
		                   }

		               }
		               try {
		                   sSelect += ")";
		                   psCheck = connectionCheck.prepareStatement(sSelect);
		                   psCheck.execute();
		                   psCheck.close();
		               }
		               catch (Exception e) {
							e.printStackTrace();
						}
		        }

		        //Now verify the indexes of the table
		        if (table.element("indexes") != null) {
		            indexes = table.element("indexes").elementIterator("index");
		            while (indexes.hasNext()) {
		                try {
		                    index = (Element) indexes.next();
		                    indexFound = hIndexes.get(table.attribute("name").getValue().toLowerCase()+"$"+index.attribute("name").getValue().toLowerCase())!=null;
		                    if (!indexFound) {
		                        sSelect = "create ";
		                        if (index.attribute("unique") != null && index.attribute("unique").getValue().equalsIgnoreCase("1")) {
		                            sSelect += " unique ";
		                        }
		                        sSelect += "index " + index.attribute("name").getValue() + " on " + table.attribute("name").getValue() + "(";
		                        indexcolumns = index.elementIterator("indexcolumn");
		                        inited = false;
		                        while (indexcolumns.hasNext()) {
		                            Element indexcolumn = (Element) indexcolumns.next();
		                            if (inited) {
		                                sSelect += ",";
		                            } else {
		                                inited = true;
		                            }
		                            if (indexcolumn.attribute("order").getValue().equalsIgnoreCase("ASC")) {
		                                sSelect += indexcolumn.attribute("name").getValue();
		                            } else {
		                                sSelect += indexcolumn.attribute("name").getValue() + " " + indexcolumn.attribute("order").getValue();
		                            }
		                        }
		                        sSelect += ")";
		                        psCheck = connectionCheck.prepareStatement(sSelect);
		                        psCheck.execute();
		                        psCheck.close();
		                    }
		                }
		                catch (Exception e) {
		                    e.printStackTrace();
		                }
		            }
		        }
		    }
			System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": update views");
		    views = model.elementIterator("view");
		    while (views.hasNext()) {
		        try {
		            view = (Element) views.next();
		            //Checking existence of view
		            //First select right connection
		            sqlIterator = view.elementIterator("sql");
		            String s = "";
		            while (sqlIterator.hasNext()) {
		                sql = (Element) sqlIterator.next();
		                if (sql.attribute("db") == null || sql.attribute("db").getValue().equalsIgnoreCase(sLocalDbType)) {
		                    s = sql.getText().replaceAll("@admin@", MedwanQuery.getInstance().getConfigString("admindbName","ocadmin"));
		                }
		            }
		            if (s.trim().length() > 0) {
		                if (view.attribute("db").getValue().equalsIgnoreCase("ocadmin")) {
		                    connectionCheck = lad_conn;
				            hTables=adminTables;
		                } else if (view.attribute("db").getValue().equalsIgnoreCase("openclinic")) {
		                    connectionCheck = loc_conn;
				            hTables=openclinicTables;
		                } else if (view.attribute("db").getValue().equalsIgnoreCase("stats")) {
		                    connectionCheck = sta_conn;
				            hTables=statsTables;
		            	}
		                //Now verify existence of view
				        boolean viewExists=hTables.get(view.attribute("name").getValue().toLowerCase())!=null;
		                bCreate = true;
		                if (viewExists) {
		                    if (view.attribute("drop") != null && view.attribute("drop").getValue().equalsIgnoreCase("1")) {
		                        //drop the view
		                        psCheck = connectionCheck.prepareStatement("drop view " + view.attribute("name").getValue());
		                        psCheck.execute();
		                        psCheck.close();
		                    } else {
		                        bCreate = false;
		                    }
		                } 
		                sqlIterator = view.elementIterator("sql");
		                while (sqlIterator.hasNext()) {
		                    sql = (Element) sqlIterator.next();
		                    if (sql.attribute("db") == null || sql.attribute("db").getValue().equalsIgnoreCase(sLocalDbType)) {
		                        st = connectionCheck.createStatement();
		                        String sq = sql.getText().replaceAll("@admin@", MedwanQuery.getInstance().getConfigString("admindbName","ocadmin"));
		                        sq = sq.replaceAll("\n", " ");
		                        sq = sq.replaceAll("\r", " ");
		                        st.addBatch(sq);
		                        st.executeBatch();
		                        st.close();
		                    }
		                }
		            }
		        }
		        catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
			loc_conn.close();
			lad_conn.close();
			sta_conn.close();
		}
		catch (Exception e) {
		    e.printStackTrace();
		}
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": end updatedb");
	}
	public static void updateLabels(String basedir){
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": reload labels");
        reloadSingleton();
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": end reload labels");
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": start updateLabels");
        String paramName, paramValue;
        String[] identifiers;
        String[] languages = MedwanQuery.getInstance().getConfigString("supportedLanguages","nl,fr,en,pt").split("\\,");
        for(int n=0;n<languages.length;n++){
    		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": load Labels."+languages[n]+".ini");
	        Properties iniProps = getPropertyFile(basedir+"/_common/xml/Labels."+languages[n]+".ini");
    		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": Labels."+languages[n]+".ini loaded");
	        Enumeration e = iniProps.keys();
	        boolean exists;
	        Hashtable langHashtable,typeHashtable,idHashtable;
	        Label label;
	        while(e.hasMoreElements()){
	            paramName = (String)e.nextElement();
	            paramValue = iniProps.getProperty(paramName);
	            identifiers = paramName.split("\\$");
	            exists=false;
	            langHashtable = MedwanQuery.getInstance().getLabels();
	            if(langHashtable!=null){
	                typeHashtable = (Hashtable) langHashtable.get(identifiers[2]);
	                if(typeHashtable!=null){
	                    idHashtable = (Hashtable) typeHashtable.get(identifiers[0].toLowerCase());
	                    if(idHashtable!=null){
	                        label = (Label) idHashtable.get(identifiers[1]);
	                        if(label!=null){
	                        	exists=true;
	                        }
	                    }
	                }
	            }
	            if(!exists){
	                MedwanQuery.getInstance().storeLabel(identifiers[0],identifiers[1],identifiers[2],paramValue,0);
	            }
	        }
        }
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": reload labels");
        reloadSingleton();
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": end updateLabels");
	}
	
	public static void updateTransactionItems(String basedir){
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": start updatetransactionitems");
		Hashtable transactionItems = MedwanQuery.getInstance().getAllTransactionItems();
        String paramName, paramValue;
        TransactionItem objTI;
        Properties iniProps = getPropertyFile(basedir+"/_common/xml/TransactionItems.ini");
        Enumeration e = iniProps.keys();
        while(e.hasMoreElements()){
            paramName = (String)e.nextElement();
            paramValue = iniProps.getProperty(paramName);
            if (transactionItems.get(paramName)==null) {
            	objTI = new TransactionItem();
                objTI.setTransactionTypeId(paramName.split("\\$")[0]);
                objTI.setItemTypeId(paramName.split("\\$")[1]);
                if(paramValue.split("\\$")!=null && paramValue.split("\\$").length>0){
                	objTI.setDefaultValue(paramValue.split("\\$")[0]);
                    if(paramValue.split("\\$")!=null && paramValue.split("\\$").length>1){
                        objTI.setModifier(paramValue.split("\\$")[1]);
                    }
                    else {
                        objTI.setModifier("");
                    }
                }
                else {
                	objTI.setDefaultValue("");
                    objTI.setModifier("");
                }
                TransactionItem.addTransactionItem(objTI);
            }
    	}
		System.out.println(new SimpleDateFormat("HH:mm:ss.SSS").format(new java.util.Date())+": end updatetransactionitems");
	}
	

    public static void reloadSingleton() {
        Hashtable labelLanguages = new Hashtable();
        Hashtable labelTypes = new Hashtable();
        Hashtable labelIds;
        net.admin.Label label;

        // only load labels in memory that are service nor function.
        Vector vLabels = net.admin.Label.getNonServiceFunctionLabels();
        Iterator iter = vLabels.iterator();

        if (Debug.enabled) Debug.println("About to (re)load labels.");
        while(iter.hasNext()){
            label = (net.admin.Label)iter.next();
            // type
            labelTypes = (Hashtable) labelLanguages.get(label.language);
            if (labelTypes == null) {
                labelTypes = new Hashtable();
                labelLanguages.put(label.language, labelTypes);
                //Debug.println("new language : "+label.language);
            }

            // id
            labelIds = (Hashtable) labelTypes.get(label.type);
            if (labelIds == null) {
                labelIds = new Hashtable();
                labelTypes.put(label.type, labelIds);
                //Debug.println("new type : "+label.type);
            }

            labelIds.put(label.id, label);
        }

        // status info
        if (Debug.enabled) {
            Debug.println("Labels (re)loaded.");

            Debug.println(" * " + labelLanguages.size() + " languages");
            Debug.println(" * " + labelTypes.size() + " types per language");
        }

        MedwanQuery.getInstance().putLabels(labelLanguages);
    }

    private static Properties getPropertyFile(String sFilename) {
        FileInputStream iniIs;
        Properties iniProps = new Properties();

        // create ini file if they do not exist
        try {
            iniIs = new FileInputStream(sFilename);
            iniProps.load(iniIs);
            iniIs.close();
        }
        catch (FileNotFoundException e) {
            // create the file if it does not exist
            try {
                new FileOutputStream(sFilename);
            }
            catch (Exception e1) {
                if (Debug.enabled) Debug.println(e1.getMessage());
            }
        }
        catch (Exception e) {
            if (Debug.enabled) Debug.println(e.getMessage());
        }
        return iniProps;
    }

}