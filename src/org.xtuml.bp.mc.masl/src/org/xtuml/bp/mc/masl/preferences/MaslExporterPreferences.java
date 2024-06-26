package org.xtuml.bp.mc.masl.preferences;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.ProjectScope;
import org.eclipse.core.runtime.preferences.IEclipsePreferences;
import org.osgi.service.prefs.BackingStoreException;
import org.xtuml.bp.io.core.CorePlugin;

public class MaslExporterPreferences {

    public static final String MASL_EXPORTER_PREFERENCES_ID = "org.xtuml.bp.mc.masl";

    // preference defaults
    private static final boolean AUTO_SELECT_ELEMENTS_DEFAULT = true;
    private static final boolean FORMAT_OUTPUT_DEFAULT = true;
    private static final boolean EMIT_ACTIVITIES_DEFAULT = true;
    private static final boolean CLEAN_BUILD_DEFAULT = true;
    private static final boolean RUN_PREBUILD_DEFAULT = true;
    private static final String OUTPUT_DESTINATION_DEFAULT = "masl/";

    // preference keys
    private static final String AUTO_SELECT_ELEMENTS_KEY = "auto_select_elements";
    private static final String FORMAT_OUTPUT_KEY = "format_output";
    private static final String EMIT_ACTIVITIES_KEY = "emit_activities";
    private static final String CLEAN_BUILD_KEY = "clean_build";
    private static final String RUN_PREBUILD_KEY = "run_prebuild";
    private static final String OUTPUT_DESTINATION_KEY = "output_desitnation";
    private static final String SELECTED_BUILD_ELEMENTS_KEY = "selected_build_elements";

    private IEclipsePreferences internalPrefs;

    private boolean autoSelectElements;
    private boolean formatOutput;
    private boolean emitActivities;
    private boolean cleanBuild;
    private boolean runPrebuild;
    private String outputDestination;
    List<UUID> selectedBuildElements;

    public MaslExporterPreferences(IProject project) {
        internalPrefs = new ProjectScope(project).getNode(MASL_EXPORTER_PREFERENCES_ID);
        loadPreferences();
    }
    
    public MaslExporterPreferences(IEclipsePreferences prefs) {
        internalPrefs = prefs;
        loadPreferences();
    }

    public boolean isAutoSelectElements() {
        return autoSelectElements;
    }

    public void setAutoSelectElements(boolean autoSelectElements) {
        this.autoSelectElements = autoSelectElements;
    }

    public boolean isFormatOutput() {
        return formatOutput;
    }

    public void setFormatOutput(boolean formatOutput) {
        this.formatOutput = formatOutput;
    }

    public boolean isEmitActivities() {
        return emitActivities;
    }

    public void setEmitActivities(boolean emitActivities) {
        this.emitActivities = emitActivities;
    }

    public boolean isCleanBuild() {
        return cleanBuild;
    }

    public void setCleanBuild(boolean cleanBuild) {
        this.cleanBuild = cleanBuild;
    }

    public boolean isRunPrebuild() {
    	return runPrebuild;
    }
    
    public void setRunPrebuild(boolean runPrebuild) {
    	this.runPrebuild = runPrebuild;
    }

    public String getOutputDestination() {
        return outputDestination;
    }

    public void setOutputDestination(String outputDestination) {
        this.outputDestination = outputDestination;
    }

    public List<UUID> getSelectedBuildElements() {
        return selectedBuildElements;
    }

    public void setSelectedBuildElements(List<UUID> selectedBuildElements) {
        this.selectedBuildElements = selectedBuildElements;
    }

    public boolean getAutoSelectElementsDefault() {
		return AUTO_SELECT_ELEMENTS_DEFAULT;
	}

	public boolean getFormatOutputDefault() {
		return FORMAT_OUTPUT_DEFAULT;
	}

	public boolean getEmitActivitiesDefault() {
		return EMIT_ACTIVITIES_DEFAULT;
	}

	public boolean getCleanBuildDefault() {
		return CLEAN_BUILD_DEFAULT;
	}

	public boolean getRunPrebuildDefault() {
		return RUN_PREBUILD_DEFAULT;
	}

	public String getOutputDestinationDefault() {
		return OUTPUT_DESTINATION_DEFAULT;
	}

	public void restoreDefaults() {
        autoSelectElements = getAutoSelectElementsDefault();
        formatOutput = getFormatOutputDefault();
        emitActivities = getEmitActivitiesDefault();
        cleanBuild = getCleanBuildDefault();
        runPrebuild = getRunPrebuildDefault();
        outputDestination = getOutputDestinationDefault();
        selectedBuildElements = new ArrayList<>();
    }

    public void loadPreferences() {
        String autoSelectElements = internalPrefs.get(AUTO_SELECT_ELEMENTS_KEY, "None");
        if ("None".equals(autoSelectElements)) {
            this.autoSelectElements = getAutoSelectElementsDefault();
        } else {
            this.autoSelectElements = Boolean.parseBoolean(autoSelectElements);
        }
        String formatOutput = internalPrefs.get(FORMAT_OUTPUT_KEY, "None");
        if ("None".equals(formatOutput)) {
            this.formatOutput = getFormatOutputDefault();
        } else {
            this.formatOutput = Boolean.parseBoolean(formatOutput);
        }
        String emitActivities = internalPrefs.get(EMIT_ACTIVITIES_KEY, "None");
        if ("None".equals(emitActivities)) {
            this.emitActivities = getEmitActivitiesDefault();
        } else {
            this.emitActivities = Boolean.parseBoolean(emitActivities);
        }
        String cleanBuild = internalPrefs.get(CLEAN_BUILD_KEY, "None");
        if ("None".equals(cleanBuild)) {
            this.cleanBuild = getCleanBuildDefault();
        } else {
            this.cleanBuild = Boolean.parseBoolean(cleanBuild);
        }
        String runPrebuild = internalPrefs.get(RUN_PREBUILD_KEY, "None");
        if ("None".equals(runPrebuild)) {
            this.runPrebuild = getRunPrebuildDefault();
        } else {
            this.runPrebuild = Boolean.parseBoolean(runPrebuild);
        }
        String outputDestination = internalPrefs.get(OUTPUT_DESTINATION_KEY, "None");
        if ("None".equals(outputDestination)) {
            this.outputDestination = getOutputDestinationDefault();
        } else {
            this.outputDestination = outputDestination;
        }
        String selectedBuildElements = internalPrefs.get(SELECTED_BUILD_ELEMENTS_KEY, "None");
        this.selectedBuildElements = new ArrayList<>();
        if (!"None".equals(selectedBuildElements)) {
            for (String element : selectedBuildElements.split(",")) {
                this.selectedBuildElements.add(UUID.fromString(element));
            }
        }
    }

    public void savePreferences() {
        try {
            internalPrefs.clear();
            if (autoSelectElements != getAutoSelectElementsDefault()) {
                internalPrefs.putBoolean(AUTO_SELECT_ELEMENTS_KEY, autoSelectElements);
            }
            if (formatOutput != getFormatOutputDefault()) {
                internalPrefs.putBoolean(FORMAT_OUTPUT_KEY, formatOutput);
            }
            if (emitActivities != getEmitActivitiesDefault()) {
                internalPrefs.putBoolean(EMIT_ACTIVITIES_KEY, emitActivities);
            }
            if (cleanBuild != getCleanBuildDefault()) {
                internalPrefs.putBoolean(CLEAN_BUILD_KEY, cleanBuild);
            }
            if (runPrebuild != getRunPrebuildDefault()) {
                internalPrefs.putBoolean(RUN_PREBUILD_KEY, runPrebuild);
            }
            if (!outputDestination.equals(getOutputDestinationDefault())) {
                internalPrefs.put(OUTPUT_DESTINATION_KEY, outputDestination);
            }
            if (!autoSelectElements && !selectedBuildElements.isEmpty()) {
                internalPrefs.put(SELECTED_BUILD_ELEMENTS_KEY,
                        selectedBuildElements.stream().map((uuid) -> uuid.toString()).collect(Collectors.joining(",")));
            }
            internalPrefs.flush();
        } catch (BackingStoreException e) {
            CorePlugin.logError("Could not save MASL exporter preferences", e);
        }
    }

}
