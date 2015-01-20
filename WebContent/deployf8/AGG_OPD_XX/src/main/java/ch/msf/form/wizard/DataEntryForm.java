package ch.msf.form.wizard;

import java.awt.Color;

import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

import ch.msf.CommonConstants;
import ch.msf.Constants;
import ch.msf.model.Aggregation;
import ch.msf.util.MiscelaneousUtils;
import ch.msf.util.StackTraceUtil;

import com.nexes.wizard.Wizard;
import com.nexes.wizard.WizardPanelDescriptor;

public class DataEntryForm extends MSFForm implements DataEntryFormI {

	@SuppressWarnings("unused")
	private static final long serialVersionUID = 1L;

	private static DataEntryForm _Prog;

	public DataEntryForm(String[] args) {
		super(args);

	}

	public boolean init() {
		_ConfigurationManager.getDbManager().setAdmin(false);

		// take care of applicationTitle parameter
		String applicationTitle = _ConfigurationManager.getConfigField("applicationTitle"); //TN95 
		
		if (System.getProperty("webstarttest") == null) {
			// modeJavaWebStart = false;
			System.out.println("DEVELOPMENT MODE = TRUE");
			_ConfigurationManager.setDevProjectPath(Constants.WORKSPACE_RES_DIR);
		}
		else
			System.out.println("DEVELOPMENT MODE = FALSE");


		_ConfigurationManager.setApplicationTitle(applicationTitle);

		boolean ret = super.init();
		if (ret) {

			// TN49: set focus indicator more visible
			UIManager.put("Button.focus", Color.blue);
			// Object obj = UIManager.getColor("Button.focusBorder");nok
			// obj = UIManager.get("Button.focusBorder");nok

			
			// Read config file and configure entryform db 
			_ConfigurationManager.configureEntryFormDbFromConfigFile();

			// read patient resources to get the languages

			String className = MiscelaneousUtils.getClassName(Aggregation.class);
			_ConfigurationManager.loadResourceLanguages(className);
		}

		return ret;

	}
	

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		try {

			_Prog = new DataEntryForm(args);

			SwingUtilities.invokeLater(_Prog);
		} catch (Exception e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, CommonConstants.ERR_MESS + StackTraceUtil.getCustomStackTrace(e), "Fatal error", JOptionPane.ERROR_MESSAGE, null);
		}

	}

	public void run() {
		try {

			boolean ok = init();
			if (!ok) {
				JOptionPane.showMessageDialog(null, CommonConstants.ERR_MESS, "Bad init", JOptionPane.ERROR_MESSAGE, null);

			} else {

				Wizard wizard = new Wizard();
				wizard.getDialog().setTitle(_ConfigurationManager.getApplicationTitle());

				WizardPanelDescriptor descriptorLogin = new LoginDescriptor();
				wizard.registerWizardPanel(LoginDescriptor.IDENTIFIER, descriptorLogin);

				WizardPanelDescriptor descriptorParam = new ParamDescriptor();
				wizard.registerWizardPanel(ParamDescriptor.IDENTIFIER, descriptorParam);

				WizardPanelDescriptor descriptorAggregationListForm = new AggregationListFormDescriptor();
				wizard.registerWizardPanel(AggregationListFormDescriptor.IDENTIFIER, descriptorAggregationListForm);

//				WizardPanelDescriptor descriptorAggregationForm = new AggregationFormDescriptor();
//				wizard.registerWizardPanel(AggregationFormDescriptor.IDENTIFIER, descriptorAggregationForm);

				WizardPanelDescriptor patientConsultationListFormDescriptor = new SectionListFormDescriptor();
				wizard.registerWizardPanel(SectionListFormDescriptor.IDENTIFIER, patientConsultationListFormDescriptor);

				WizardPanelDescriptor patientConsultationFormDescriptor = new SectionFormDescriptor();
				wizard.registerWizardPanel(SectionFormDescriptor.IDENTIFIER, patientConsultationFormDescriptor);

				WizardPanelDescriptor descriptorFinal = new FinalDescriptor();
				wizard.registerWizardPanel(FinalDescriptor.IDENTIFIER, descriptorFinal);

				boolean next = true;
				wizard.setCurrentPanel(LoginDescriptor.IDENTIFIER, next);
//				 wizard.setCurrentPanel(ParamDescriptor.IDENTIFIER, next);

				int ret = wizard.showModalDialog();

				System.out.println("Dialog return code is (0=Finish,1=Cancel,2=Error): " + ret);
			}

		} catch (Exception e) {
			manageException(e);
		}
	}



}
