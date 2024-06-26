.//====================================================================
.//
.// File:      java.arc
.//
.//====================================================================
.//
.invoke arc_env = GET_ENV_VAR( "PTC_MC_ARC_DIR" )
.assign mc_archetypes = arc_env.result
.if ( mc_archetypes == "" )
  .print "\nERROR: Environment variable PTC_MC_ARC_DIR not set."
  .exit 100
.end if
.invoke project_env = GET_ENV_VAR( "PROJECT_ROOT" )
.assign project_root = project_env.result
.if ( project_root == "" )
  .print "\nERROR: Environment variable PROJECT_ROOT not set."
  .exit 100
.end if
.//
.//
.// ss_only allows for a specific package and/or class to be generated alone
.invoke mc_ss_only_check = GET_ENV_VAR( "PTC_MCC_SS_ONLY")
.assign mc_ss_only = mc_ss_only_check.result
.invoke mc_class_only_check = GET_ENV_VAR( "PTC_MCC_CLASS_ONLY")
.assign mc_class_only = mc_class_only_check.result
.invoke mc_ss_start_check = GET_ENV_VAR( "PTC_MCC_SS_START")
.assign mc_ss_start = mc_ss_start_check.result
.invoke mc_ss_end_check = GET_ENV_VAR( "PTC_MCC_SS_END")
.assign mc_ss_end = mc_ss_end_check.result
.invoke mc_root_pkg_name = GET_ENV_VAR("PTC_MCC_ROOT")
.assign mc_root_pkg = mc_root_pkg_name.result
.invoke mc_pass_index_check = GET_ENV_VAR("PTC_MCC_PASS_INDEX")
.assign mc_pass_index = mc_pass_index_check.result
.select many splits from instances of PACKAGE_IN_SPLIT
.//
.include "${mc_archetypes}/do_type.inc"
.include "${mc_archetypes}/arch_utils.inc"
.include "${mc_archetypes}/mfp_utils.inc"
.include "${mc_archetypes}/enums.inc"
.include "${mc_archetypes}/model_consistency.inc"
.include "${mc_archetypes}/../org.xtuml.bp.core/arc/generate_RGO_resolution_methods.inc"
.//
.//====================================================================
.//
.function in_split
  .param inst_ref pkg
  .param string pass_index
  .assign attr_result = false
  .select any split_pkg from instances of PACKAGE_IN_SPLIT where ((selected.PackageName == pkg.Name) and (selected.PassIndex == pass_index))
  .if (not_empty split_pkg)
    .assign attr_result = true
  .else
    .select one parent_pkg related by pkg->PE_PE[R8001]->EP_PKG[R8000]
    .if (not_empty parent_pkg)
      .invoke parent_in_split = in_split(parent_pkg, pass_index)
      .assign attr_result = parent_in_split.result
    .end if
  .end if
.end function
.//
.//====================================================================
.//
.function has_id_assigner
  .param inst_ref_set attributes   .// O_ATTR
  .//
  .assign attr_result = false
  .for each attribute in attributes
    .invoke iuia = is_uniqueid_id_attr(attribute)
    .if ( iuia.result )
      .assign attr_result = true
      .break for
    .end if
  .end for
.end function
.//
.//====================================================================
.//
.function find_id
  .param inst_ref object   .// O_OBJ
  .//
  .select any id related by object->O_ID[R104]->O_OIDA[R105] where (selected.Oid_ID == 0)
  .if (empty id)
    .select any id related by object->O_ID[R104]->O_OIDA[R105] where (selected.Oid_ID == 1)
  .end if
  .if (empty id)
    .select any id related by object->O_ID[R104]->O_OIDA[R105] where (selected.Oid_ID == 2)
  .end if
  .select one attr_id related by id->O_ID[R105]
.end function
.//
.//====================================================================
.//
.function get_reflexive_phrase
  .param inst_ref rel  .// R_REL
  .param inst_ref rto  .// R_RTO
  .param boolean reverse
  .//
  .assign attr_result = ""
  .invoke is_refl = is_reflexive( rel )
  .if ( is_refl.result )
    .if(reverse)
      .select one part related by rel->R_SIMP[R206]->R_PART[R207]
      .if(not_empty part)
        .assign attr_result = "$cr{part.Txt_Phrs}"
      .else
        .select one aone related by rel->R_ASSOC[R206]->R_AONE[R209]
        .select one aoth related by rel->R_ASSOC[R206]->R_AOTH[R210]
        .if ( rto.OIR_ID == aone.OIR_ID )
          .assign attr_result = "$cr{aone.Txt_Phrs}"
        .else
          .assign attr_result = "$cr{aoth.Txt_Phrs}"
        .end if
      .end if
    .else
      .select one form related by rel->R_SIMP[R206]->R_FORM[R208]
      .if (not_empty form)
        .assign attr_result = "$cr{form.Txt_Phrs}"
      .else
        .select one aone related by rel->R_ASSOC[R206]->R_AONE[R209]
        .select one aoth related by rel->R_ASSOC[R206]->R_AOTH[R210]
        .if ( rto.OIR_ID == aone.OIR_ID )
          .assign attr_result = "$cr{aoth.Txt_Phrs}"
        .else
          .assign attr_result = "$cr{aone.Txt_Phrs}"
        .end if
      .end if 
    .end if
  .end if
.end function
.//
.//====================================================================
.//
.function get_first_attribute
  .param inst_ref any_attribute   .// O_ATTR
  .//
  .assign attr_first_attribute = any_attribute
  .select one prior_attribute related by attr_first_attribute->O_ATTR[R103.'succeeds']
  .while ( not_empty prior_attribute )
    .assign attr_first_attribute = prior_attribute
    .select one prior_attribute related by attr_first_attribute->O_ATTR[R103.'succeeds']
  .end while
.end function
.//
.//====================================================================
.//
.function get_file_header
  .param string file_name
//====================================================================
//
// File:      ${file_name}
//
// WARNING: Do not edit this generated file
// Generated by ${info.arch_file_name}
//
//====================================================================
.end function
.//
.//====================================================================
.//
.function generate_event_classes
  .param inst_ref object
  .param inst_ref_set events
  .param string class_sm_tag
  .//
  .// Generate Event Classes 
abstract class EV_$u_{object.Name}${class_sm_tag} extends genericEvent_c 
{
  public abstract int getEvtcode() ;
}
      .for each event in events 
  class EV_$u_{object.Name}${class_sm_tag}_$u_{event.Mning} extends EV_$u_{object.Name}${class_sm_tag}
  {
    // supplemental event data
        .select many parameters related by event->SM_EVTDI[R532]
        .invoke SortSetAlphabeticallyByNameAttr( parameters )
        .assign item_count = cardinality parameters
        .assign item_number = 0
        .assign param_delimiter = ""
        .while ( item_number < item_count )
          .for each parameter in parameters
            .if ( parameter.Order == item_number )
              .select one par_type related by parameter->S_DT[R524]
              .invoke type = do_type(par_type)
    public ${type.body} edi_$l_{parameter.Name} ;
              .assign param_delimiter = ","
              .break for
            .end if
          .end for
          .assign item_number = item_number + 1
        .end while
    static final int EVCD_$u_{object.Name}_$u_{event.Mning} = ${event.Numb} ;
    public final int getEvtcode()
    {
      return EVCD_$u_{object.Name}_$u_{event.Mning} ;
    }
  }
      .end for
.end function
.//
.//====================================================================
.//
.function generate_state_machine
  .param inst_ref object  .// O_OBJ
  .param inst_ref sm  .// SM_SM
  .param frag_ref package
  .param string class_sm_tag
  .param string instance_handle
  .//
  .select many events related by sm->SM_EVT[R502]
  .select any start_state related by sm->SM_STATE[R501]
  .select many states related by sm->SM_STATE[R501]
  .assign lowest = 9999
  .assign count = 0
  .for each state in states
    .if (state.Numb < lowest)
      .assign lowest = state.Numb
      .assign start_state = state
    .end if
    .assign count = count + 1
  .end for
  .invoke csa = get_current_state_accessor_name()
  .assign class_static = ""
  .if ( class_sm_tag != "" )
    .assign class_static = "static"
  .end if
  public static final int
  .for each state in states 
    ST_$u_{object.Name}_$u_{state.Name} = ${state.Numb}\
    .if (not_last states)
, 
    .else
;
    .end if
  .end for

  ${class_static} private int state = ST_$u_{object.Name}_$u_{start_state.Name} ;
  ${class_static} private Vector<genericEvent_c> eventQueue = new Vector<genericEvent_c>(10,10) ;
  ${class_static} private Vector<genericEvent_c> selfEventQueue = new Vector<genericEvent_c>(10,10) ;

  public int ${csa.body}() { return state; }
    
  .for each event in events
  static final int EVCD_$u_{object.Name}_$u_{event.Mning} = ${event.Numb} ;
  ${class_static} public synchronized void $cr{event.Mning}( boolean self_directed \
    .select many parameters related by event->SM_EVTDI[R532]
    .invoke SortSetAlphabeticallyByNameAttr( parameters )
    .assign item_count = cardinality parameters
    .assign item_number = 0
    .while ( item_number < item_count )
      .for each parameter in parameters
        .if ( parameter.Order == item_number )
          .select one par_type related by parameter->S_DT[R524]
          .invoke type = do_type(par_type)
, final ${type.body} p_$l_{parameter.Name}\
          .break for
        .end if
      .end for
      .assign item_number = item_number + 1
    .end while
)
  {
    EV_$u_{object.Name}${class_sm_tag}_$u_{event.Mning} incoming_event = new EV_$u_{object.Name}${class_sm_tag}_$u_{event.Mning}() ;
    .for each parameter in parameters
    incoming_event.edi_$l_{parameter.Name} = p_$l_{parameter.Name} ;
    .end for
    if (self_directed == true) {
      selfEventQueue.addElement(incoming_event) ;
    }
    else {
      eventQueue.addElement(incoming_event) ;
    }
    ${instance_handle}notify() ;
  }
  .end for

  public synchronized void takeEvent(genericEvent_c incoming_event)
  {
    eventQueue.addElement(incoming_event) ;
    ${instance_handle}notify() ;
  }

  public synchronized void procEvent()
  {
  .if ( class_sm_tag == "_CLASS" )
    ${package.application_root_class} modelRoot = ${package.application_root_class}.getDefaultInstance();
  .else
    ModelRoot modelRoot = getModelRoot();
  .end if
    EV_$u_{object.Name}${class_sm_tag} currentEvent ;
    if (selfEventQueue.size() != 0) {
      currentEvent = (EV_$u_{object.Name}${class_sm_tag})selfEventQueue.firstElement() ;
      selfEventQueue.removeElement(currentEvent) ;
    }
    else {
      currentEvent = (EV_$u_{object.Name}${class_sm_tag})eventQueue.firstElement() ;
      if (currentEvent != null) {
        eventQueue.removeElement(currentEvent) ;
      }
    }
    if (currentEvent != null) {
      switch (currentEvent.getEvtcode())
      {
  .for each event in events
        case EVCD_$u_{object.Name}_$u_{event.Mning}:
        {
        ${package.application_root_class}.log.println(ILogger.STATE_MACHINE, "${object.Name}", " Event dequeued: $cr{object.Name}.$cr{event.Mning} in " + state) ; 
          final EV_$u_{object.Name}${class_sm_tag}_$u_{event.Mning} arch_event = (EV_$u_{object.Name}${class_sm_tag}_$u_{event.Mning})currentEvent ;
          switch (state)
          {
    .select many STTEntries related by event->SM_SEVT[R525]->SM_SEME[R503]
    .for each STTEntry in STTEntries
      .select any newStateTxn related by STTEntry->SM_NSTXN[R504]
      .select any evtIgnored related by STTEntry->SM_EIGN[R504]
      .select any state related by STTEntry->SM_STATE[R503]
      .if (not_empty newStateTxn)
         .select any newstate related by newStateTxn->SM_TXN[R507]->SM_STATE[R506]
          case ST_$u_{object.Name}_$u_{state.Name}:
         .select one action related by newstate->SM_MOAH[R511]->SM_AH[R513]->SM_ACT[R514]
         .// Generate Action Language Code using Processing Subsystem Instances
         .select one actionblock related by action->ACT_SAB[R691]->ACT_ACT[R698]
         .select any block related by actionblock->ACT_BLK[R666]
         .invoke blck = blck_xlate(block)
            {
${blck.body}
            }
            state = ST_$u_{object.Name}_$u_{newstate.Name} ;
            break ;
      .elif (not_empty evtIgnored)
               case ST_$u_{object.Name}_$u_{state.Name}:
                // Event Ignored
               break ;
      .end if
    .end for
            default:
    .if ( package.is_eclipse_plugin )
          ${package.plugin_classname}.logError(" Can't Happen:  ${object.Name}${class_sm_tag} state = " + state + " event = ${event.Drv_Lbl}:${event.Mning}", null);
    .else
          System.err.println(" Can't Happen:  ${object.Name}${class_sm_tag} state = " + state + " event = ${event.Drv_Lbl}:${event.Mning}") ; 
    .end if
          // throw cantHappenException here ;
          }  // end state switch
          break ;
        }
  .end for
      } // end currentEvent switch
    } // end if currentEvent valid
  } // end ${object.Name} procEvent
.end function
.//
.//====================================================================
.//
.function create_full_constructor_arguments
  .param inst_ref object   .// O_OBJ
  .param boolean add_types
  .//
  .// find the first attribute as defined by the ordering
  .// relationship R103.   This is the only place where attribute
  .// order has to match what's specified by the model
  .select any attribute related by object->O_ATTR[R102]
  .invoke gfa_result = get_first_attribute( attribute )
  .assign attribute = gfa_result.first_attribute
  .//
  .//
  .assign first_time = true
  .while ( not_empty attribute )
    .select one type related by attribute->S_DT[R114]
    .select one rattr related by attribute->O_RATTR[R106]
    .if (not_empty rattr)
      .select one type related by rattr->O_BATTR[R113]->O_ATTR[R106]->S_DT[R114]
    .end if
    .invoke aip = attr_is_persistent(attribute)
    .if ( aip.result )
      .invoke an = get_attribute_name ( attribute )
      .invoke at = do_type ( type )
      .if ( not first_time )
,
      .end if
      .if ( add_types )
       ${at.body} \
      .end if
p_${an.body}\
    .end if
    .assign first_time = false
    .select one attribute related by attribute->O_ATTR[R103.'precedes']
  .end while
.end function
.//
.//====================================================================
.//
.function create_full_constructor_body
  .param inst_ref_set attributes  .// O_ATTR
  .param boolean register_ism
  .param string var_name   .//  For example "source."
  .//
  .assign attr_unique_id = ""
  .for each attribute in attributes
    .invoke aip = attr_is_persistent(attribute)
    .invoke an = get_attribute_name ( attribute )
    .if ( aip.result )
       .invoke ibaaui = is_base_attribute_a_unique_id(attribute)
       .if (ibaaui.is_unique_id)
         .invoke iuia = is_uniqueid_id_attr(attribute)
         .if (iuia.result)
           .if(attr_unique_id == "")
             .assign attr_unique_id = an.body
           .end if
         .end if
       //pre-process the uuid so that we re-use null uuid instance rather then creating a new one.           
       ${var_name}${an.body} = IdAssigner.preprocessUUID(p_${an.body});
         .invoke iref = is_referential_attr(attribute)
         .if(not iref.result)
       //extract 28 bit value only            
       ${var_name}${an.body}LongBased = 0xfffffff & p_${an.body}.getLeastSignificantBits();
         .end if
       .else
       ${var_name}${an.body} = p_${an.body};
       .end if
    .else
       // default value for ${an.body}
    .end if
  .end for
        
  .if (register_ism)
    // register with event queue poller
    Activepoller_c.register(this) ;
  .end if
.end function
.//
.//====================================================================
.//
.function get_unique_id_attr_id
  .param inst_ref_set attributes  .// O_ATTR
  .assign attr_Attr_ID = 0
  .for each attribute in attributes
    .invoke aip = attr_is_persistent(attribute)
    .if ( aip.result )
       .invoke ibaaui = is_base_attribute_a_unique_id(attribute)
       .if (ibaaui.is_unique_id)
         .invoke iuia = is_uniqueid_id_attr(attribute)
         .if (iuia.result)
           .if(attr_Attr_ID == 0)
             .assign attr_Attr_ID = attribute.Attr_ID
           .end if
         .end if
       .end if
    .end if
  .end for
.end function
.//
.//====================================================================
.//
  .function get_referential_var_name_of_rgo
     .param inst_ref oref
        .//
        .//
        .select one rtida related by oref->O_RTIDA[R111]
        .select one idAttr related by rtida->O_OIDA[R110]->O_ATTR[R105]
        .invoke idaa = get_attribute_accessor( idAttr )
        .assign attr_id_attr_accessor = "${idaa.body}"
        .select one rgo related by oref->R_RGO[R111]
        
        .//
        .assign attr_var_name = "unknown"
        .//
        .select any frm_ref_end related by rgo->R_FORM[R205]
        .if (not_empty frm_ref_end)
          .select any spc_rel related by frm_ref_end->R_SIMP[R208]
          .select any tar_rel_end related by spc_rel->R_PART[R207]
          .select any rto related by tar_rel_end->R_RTO[R204]
          .select any tar_obj related by rto->R_OIR[R203]->O_OBJ[R201]
          .assign tar_txt_phrs = "${tar_rel_end.Txt_Phrs}"
          .invoke grvn = get_referential_var_name( tar_obj, tar_txt_phrs )
          .assign attr_var_name = "${grvn.body}"
        .end if
        .select any ass_rel_end related by rgo->R_ASSR[R205]
        .if (not_empty ass_rel_end)
          .select any spc_rel related by ass_rel_end->R_ASSOC[R211]
          .select any tar_rel_aoth_end related by spc_rel->R_AOTH[R210]
          .assign tar_txt_phrs = "${tar_rel_aoth_end.Txt_Phrs}"
          .select any tar_rto related by tar_rel_aoth_end->R_RTO[R204]
          .if ( tar_rto.OIR_ID != rtida.OIR_ID )
            .select any tar_rel_aone_end related by spc_rel->R_AONE[R209] 
            .assign tar_txt_phrs = "${tar_rel_aone_end.Txt_Phrs}"
            .select any tar_rto related by tar_rel_aone_end->R_RTO[R204]
          .end if
          .select any tar_obj related by tar_rto->R_OIR[R203]->O_OBJ[R201]
          .invoke grvn = get_referential_var_name( tar_obj, tar_txt_phrs )
          .assign attr_var_name = "${grvn.body}"
        .end if
        .select any sub_rel_end related by rgo->R_SUB[R205]
        .if (not_empty sub_rel_end)
          .select any spc_rel related by sub_rel_end->R_SUBSUP[R213]
          .select any tar_rel_end related by spc_rel->R_SUPER[R212]
          .select any rto related by tar_rel_end->R_RTO[R204]
          .select any tar_obj related by rto->R_OIR[R203]->O_OBJ[R201]
          .assign tar_txt_phrs = "is supertype"
          .invoke grvn = get_referential_var_name( tar_obj, tar_txt_phrs )
          .assign attr_var_name = "${grvn.body}"
        .end if
  .end function
.//
.//====================================================================
.//
  .function get_referential_var_name_of_rgo_super_only
     .param inst_ref oref
        .//
        .//
        .select one rtida related by oref->O_RTIDA[R111]
        .select one idAttr related by rtida->O_OIDA[R110]->O_ATTR[R105]
        .invoke idaa = get_attribute_accessor( idAttr )
        .assign attr_id_attr_accessor = "${idaa.body}"
        .select one rgo related by oref->R_RGO[R111]
        
        .//
        .assign attr_var_name = "unknown"
        .//
        .select any sub_rel_end related by rgo->R_SUB[R205]
        .if (not_empty sub_rel_end)
          .select any spc_rel related by sub_rel_end->R_SUBSUP[R213]
          .select any tar_rel_end related by spc_rel->R_SUPER[R212]
          .select any rto related by tar_rel_end->R_RTO[R204]
          .select any tar_obj related by rto->R_OIR[R203]->O_OBJ[R201]
          .assign tar_txt_phrs = "is supertype"
          .invoke grvn = get_referential_var_name( tar_obj, tar_txt_phrs )
          .assign attr_var_name = "${grvn.body}"
        .end if
  .end function
.//
.//====================================================================
.//
.select any root_pkg from instances of EP_PKG where (selected.Name == mc_root_pkg)
.invoke rpn_result = get_root_pkg_name( root_pkg )
.include "color/$l{rpn_result.body}_package_spec.clr"
.invoke package = get_package()
.assign application_root_class = package.application_root_class
.if(application_root_class == "Ooaofooa")
  .invoke containment = markComponentsAndContainments()
.end if
.//

.//
.include "${mc_archetypes}/value.inc"
.include "${mc_archetypes}/statement.inc"
.include "${mc_archetypes}/block.inc"
.include "${mc_archetypes}/referring.inc"
.include "${mc_archetypes}/referred_to.inc"
.//
.include "${mc_archetypes}/translate_oal.inc"
.// - put in by wgt
.print "Time is: ${info.date}"
.assign send_changes = package.is_eclipse_plugin
.assign already_translated = false
.if ((mc_class_only == "") and (mc_ss_only == ""))
  .// Translate all OAL unless looking for a specific package or class.
  .invoke translate_all_oal( mc_root_pkg, application_root_class, send_changes );
  .assign already_translated = true
.end if
.print "Time is: ${info.date}"
.//
.//
.assign translate_enabled = true
.select any ee_pkg from instances of EP_PKG where (selected.Name == "External Entities")
.invoke ees_in_split = in_split(ee_pkg, mc_pass_index)
.if ((mc_ss_start != "") or ((not_empty splits) and (not ees_in_split.result)))
  .assign translate_enabled = false
.end if
.//
.if ((translate_enabled == true) and ((mc_ss_only == "") and (mc_class_only == "")))
  .invoke gen_enum_classes( package.name, package.location, project_root )
  .//
  .//
  .// Generate a class for each External Entity (except TIM)
  .//
  .// This should really recursively descend to find EE's. At the moment it relies on EE's being in the top tier of packages.
  .select many ees related by root_pkg->PE_PE[R8000]->EP_PKG[R8001]->PE_PE[R8000]->S_EE[R8001] where (("$l{selected.Descrip:Translate}" != "false") and (selected.Key_Lett != "TIM"))
  .for each ee in ees
package ${package.name} ;
    .invoke eecn = get_ee_class_name(ee)
    .invoke gfh = get_file_header("${package.name}.${eecn.body}.java")
${gfh.body}\

    .if ("${ee.Descrip:Import}" != "")
import ${ee.Descrip:Import};
    .end if
    .select many bridges related by ee->S_BRG[R19]
    .for each br in bridges
      .if ("${br.Descrip:Import}" != "")
import ${br.Descrip:Import};
      .end if
    .end for

     // ${ee.Name}
    .invoke eecn = get_ee_class_name(ee)
  public class ${eecn.body} {
    .if ("${ee.Descrip:Data}" != "")
    static ${ee.Descrip:Data} = null;
    .end if
    .for each br in bridges
      .if ("${br.Descrip:Data}" != "")
    static ${br.Descrip:Data} = null;
      .end if
    .end for
    .for each bridge in bridges
      .select one ret_type related by bridge->S_DT[R20]
      .invoke type = do_type(ret_type)
    public static ${type.body} $cr{bridge.Name}(\
      .select many parameters related by bridge->S_BPARM[R21]
      .invoke SortSetAlphabeticallyByNameAttr( parameters )
      .assign item_count = cardinality parameters
      .assign item_number = 0
      .assign param_delimiter = ""
      .while ( item_number < item_count )
        .for each parameter in parameters
          .if ( parameter.Order == item_number )
            .select one par_type related by parameter->S_DT[R22]
            .invoke type = do_type(par_type)
            .assign dims = ""
            .if ("" != parameter.Dimensions)
              .assign dims = "[]"
            .end if
${param_delimiter}final ${type.body}${dims} p_$cr{parameter.Name}\
            .assign param_delimiter = ","
            .break for
          .end if
        .end for
        .assign item_number = item_number + 1
      .end while
)
    {
      .// Generate Action Language Code using Processing Subsystem Instances
      .if ("${bridge.Descrip:Translate}" == "native")
        .print "${bridge.Name} written as native code"
${bridge.Action_Semantics}
      .else
      ${package.application_root_class}.log.println(ILogger.BRIDGE, "${bridge.Name}", " Bridge entered: $cr{ee.Name}::$cr{bridge.Name}") ; 
        .print " Bridge ${bridge.Name}"
        .select any actionblock related by bridge->ACT_BRB[R697]->ACT_ACT[R698]
        .select any block related by actionblock->ACT_BLK[R666]
        .invoke blck = blck_xlate(block)
${blck.body}
      .end if
    } // End ${bridge.Name}
       
    .end for
  } // End ${eecn.body}

    .emit to file "${project_root}/${package.location}/${eecn.body}.java"
  .end for
  .//   
  .// End External Entities
  .//
.end if 
.include "${project_root}/color/$l{rpn_result.body}_import_spec.clr"
.// Generate a class for each object
.//
.select many packages from instances of EP_PKG
.for each pkg in packages
  .invoke pkg_in_split = in_split(pkg, mc_pass_index)
  .if (not_empty splits)
    .if (pkg_in_split.result)
      .assign translate_enabled = true
    .else
      .assign translate_enabled = false
    .end if
  .else
    .if ((mc_ss_start != "") and (mc_ss_start == "${pkg.Name}"))
      .assign translate_enabled = true
    .end if
    .if ((mc_ss_end != "") and (mc_ss_end == "${pkg.Name}"))
      .assign translate_enabled = false
      .break for
    .end if
  .end if
  .if ((translate_enabled == true) and ((mc_ss_only == "") or (mc_ss_only == pkg.Name)))
    .if ("${pkg.Descrip:Translate}" == "false")
      .print "Package ${pkg.Name} ignored"
    .else
      .if (mc_ss_only == pkg.Name)
        .// Translate OAL before translating the specifically requested class.
        .invoke translate_all_oal( mc_root_pkg, application_root_class, send_changes );
        .assign already_translated = true
      .end if
      .invoke tcn = get_test_class_name()
      .select many objects related by pkg->PE_PE[R8000]->O_OBJ[R8001]
      .for each object in objects
        .if ((mc_class_only == "") or (mc_class_only == object.Name))
        .print " Translating Object:   ${object.Name}"
        .invoke cn = get_class_name ( object )
        .assign class_name = "${cn.body}"
        .invoke p = is_persistent(object)
        .assign persistent = p.result
        .invoke r = is_componentRootElement(object)
        .assign is_compRoot = r.result
        .invoke prime_id_attrs = get_all_primary_id_attributes(object)
        .invoke key_result = get_unique_instance_key(prime_id_attrs.result,"")
      
package ${package.name} ;
        .invoke gfh = get_file_header("${package.name}.${class_name}.java")
${gfh.body}\

        .invoke result = get_imports()
${result.import}
import java.util.* ;
import java.lang.reflect.*;
        .if (package.is_eclipse_plugin)
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.xtuml.bp.core.util.PersistenceUtil;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.xtuml.bp.core.ui.marker.UmlProblem;
          .select any filterOp related by object->O_TFR[R115] where (selected.Name == "actionFilter")
          .if ( not_empty filterOp )
import org.eclipse.ui.IActionFilter;
          .end if
          .if ( object.AdapterName == "IProject" )
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.resources.IProject;
import org.eclipse.ui.IContributorResourceAdapter;
          .end if
        .end if
        .if ("${pkg.Descrip:Import}" != "")
import ${pkg.Descrip:Import};
        .end if
        .if ("${object.Descrip:Import}" != "")
import ${object.Descrip:Import};
        .end if
        .if (package.is_eclipse_plugin)
import org.xtuml.bp.core.common.*;      
        .else
import ${package.name}.common.*;      
        .end if
        .select many events related by object->SM_ISM[R518]->SM_SM[R517]->SM_EVT[R502]
        .invoke gec = generate_event_classes( object, events, "" )
${gec.body}\

public class ${class_name}\
        .select one ism related by object->SM_ISM[R518]
        .if (not_empty ism)
          .if (package.is_eclipse_plugin)
 extends NonRootModelElement implements timerClient_c, ActiveObject_c, IAdaptable, Cloneable\
          .else
 extends NonRootModelElement implements timerClient_c, ActiveObject_c\
          .end if
        .else
          .if (package.is_eclipse_plugin)
 extends NonRootModelElement implements IAdaptable, Cloneable\
          .else
 extends NonRootModelElement\
          .end if
        .end if

{
  // Public Constructors
        .select many attributes related by object->O_ATTR[R102]
        .assign num_volatile_attrs = 0
        .for each attribute in attributes
          .invoke aip = attr_is_persistent(attribute)
          .if ( not aip.result )
            .assign num_volatile_attrs = num_volatile_attrs + 1
          .end if
        .end for
        .if ( ((cardinality attributes)-num_volatile_attrs) > 0 )
  public ${class_name}(ModelRoot modelRoot,
          .invoke cfca = create_full_constructor_arguments(object, true)
${cfca.body}\
)
  {
    super(modelRoot);
          .assign register_ism = not_empty ism
          .invoke cfcb = create_full_constructor_body(attributes, register_ism, "" )
${cfcb.body}\
          .if(cfcb.unique_id != "")
    setUniqueId(${cfcb.unique_id});
          .end if
          .if(key_result.found_key)
    Object [] key = ${key_result.key};
    addInstanceToMap(key);
          .end if
  }
          .if (package.is_eclipse_plugin)
  static public ${class_name} createProxy(ModelRoot modelRoot,
${cfca.body}, String p_contentPath, String modelPath, IPath p_localPath)
  {
            .if ( object.AdapterName == "IProject" )
        if (!modelRoot.isCompareRoot()
                && !modelRoot.getId().equals(
                        ModelRoot.CLIPBOARD_MODEL_ROOT_NAME)) {
        modelRoot=((ModelRoot) Ooaofooa.getDefaultInstance());
      }
            .end if
      ModelRoot resolvedModelRoot = ModelRoot.findModelRoot(modelRoot, p_contentPath, p_localPath);
      // if a model root was not resolved it is most likely
      // due to a missing file of the proxy, defualt back to
      // the original model root
      if(resolvedModelRoot != null)
        modelRoot = resolvedModelRoot;
      InstanceList instances = modelRoot.getInstanceList(${class_name}.class);
      ${class_name} new_inst = null;
      synchronized(instances) {
            .invoke id_result = find_id(object)
            .assign id = id_result.id
            .select many id_attrs related by id->O_OIDA[R105]->O_ATTR[R105]
            .invoke local_key_result = get_unique_instance_key(id_attrs,"p_");
            .if(local_key_result.found_key)
      Object[] key = ${local_key_result.key};
          new_inst = (${class_name}) instances.get(key) ;
            .end if
    String contentPath = PersistenceUtil.resolveRelativePath(
            p_localPath,
            new Path(p_contentPath));
    if(modelRoot.isNewCompareRoot()) {
          // for comparisons we do not want to change
          // the content path
          contentPath = p_contentPath;
    }
    if ( new_inst != null && !modelRoot.isCompareRoot()) {
        PersistableModelComponent pmc = new_inst.getPersistableComponent();
        if (pmc == null) {
            // dangling reference, redo this instance
            new_inst.batchUnrelate();
            .invoke cfcb = create_full_constructor_body(attributes, false, "new_inst." )
${cfcb.body}\
        }
    }
    if ( new_inst == null && modelPath != null ) {
        // try to look the instance up by model path
        new_inst = $cr{object.Name}Instance(modelRoot, selected -> {
          try {
            return ((NonRootModelElement) selected).getPath().equals(modelPath);
          } catch (NullPointerException e) {
            // 'getPath' may throw an NPE if the model data is not consistent
            return false;
          }
        });
            .invoke foreign_key_result = get_unique_instance_key(id_attrs,"new_inst.");
            .if(foreign_key_result.found_key)
        if (new_inst != null) {
            Object[] targetKey = ${foreign_key_result.key};
            instances.addAlias(targetKey, key);
        }
            .end if
    }
    if ( new_inst == null ) {
        // there is no instance matching the id, create a proxy
        // if the resource doesn't exist then this will be a dangling reference
        new_inst = new ${class_name}(modelRoot,
            .invoke cfca_nt = create_full_constructor_arguments(object, false)
${cfca_nt.body}
);
        new_inst.m_contentPath = contentPath;
        new_inst.m_modelPath = modelPath;
            .if ( object.AdapterName == "IFile" )
    new_inst.setComponent(null);
            .end if
    }
    }
    return new_inst;
  }

  static public ${class_name} resolveInstance(ModelRoot modelRoot,
${cfca.body}\
, String modelPath){
            .if ( object.AdapterName == "IProject" )
      if(!modelRoot.isCompareRoot()) {
        modelRoot=((ModelRoot) Ooaofooa.getDefaultInstance());
      }
            .end if
            .assign cached = ""
            .// special case 
            .// the SM_ISM and SM_ASM id attrs are referential
            .// so we need to get the cached value
            .if ( (object.Key_lett == "SM_ISM") or (object.Key_Lett == "SM_ASM") )
              .assign cached = "CachedValue"
            .end if
    InstanceList instances = modelRoot.getInstanceList(${class_name}.class);
    ${class_name} new_inst = null;
    synchronized(instances) {
        Object [] key = {
            .for each id_attr in id_attrs
              .invoke an = get_attribute_name ( id_attr )
              .invoke result = get_base_attribute_type( id_attr )
              .assign type = result.type
              .// since we are searching a proxy we need to compare with original member variable
              .// not thru accessor which may return 0
              .invoke check_primitive_java = is_java_primitive_type(type)
              .if (not check_primitive_java.isPrimitive)
        p_${an.body}
              .else
        new UUID(0, new Long(p_${an.body}))
              .end if
              .if ( not_last id_attrs )
        ,
              .end if
            .end for
            };
        new_inst = (${class_name}) instances.get(key);
        if (new_inst == null && modelPath != null) {
          // try to look the instance up by model path
          new_inst = $cr{object.Name}Instance(modelRoot, selected -> {
            try {
              return ((NonRootModelElement) selected).getPath().equals(modelPath);
            } catch (NullPointerException e) {
              // 'getPath' may throw an NPE if the model data is not consistent
              return false;
            }
          });
            .invoke foreign_key_result = get_unique_instance_key(id_attrs,"new_inst.");
            .if(foreign_key_result.found_key)
        if (new_inst != null) {
            Object[] targetKey = ${foreign_key_result.key};
            instances.addAlias(targetKey, key);
        }
            .end if
        }
        if (new_inst != null && !modelRoot.isCompareRoot()) {
           new_inst.convertFromProxy();
           new_inst.batchUnrelate();
            .invoke cfcb_source = create_full_constructor_body(attributes, false, "new_inst.")
${cfcb_source.body}\
        } else {
      // there is no instance matching the id
    new_inst = new ${class_name}(modelRoot,
${cfca_nt.body}
);
}
      }
    return new_inst;
  }
          .end if   .//         .if (package.is_eclipse_plugin)
        .end if   .// .if ( (not has_current_state_attr) or ((cardinality attributes) != 1) )
  public ${class_name}(ModelRoot modelRoot)
  {
    super(modelRoot);
        .assign unique_id_str = ""
        .for each attribute in attributes
          .select one type related by attribute->S_DT[R114]
          .invoke an = get_attribute_name ( attribute )
          .invoke iuia = is_uniqueid_id_attr(attribute)
          .if (iuia.result)
            .if(unique_id_str == "")
              .assign unique_id_str = an.body
            .end if;
     ${an.body} = idAssigner.createUUID();
          .end if
          .// If the type is 'same_as_Base', replace type with the actual type.
          .// This is done after the test for unique_id because we do not wish
          .// to consume unique ids on referentials since they will always get
          .// overwritten in due course.
          .select one rattr related by attribute->O_RATTR[R106]
          .if (not_empty rattr)
            .select one type related by rattr->O_BATTR[R113]->O_ATTR[R106]->S_DT[R114]
          .end if        
          .assign default_value = "${attribute.Descrip:Not_participating_value}"
          .if (type.Name == "string")
     ${an.body} = "${default_value}";   
          .elif ((type.Name == "unique_id") and (not iuia.result))
     ${an.body} = IdAssigner.NULL_UUID;   
          .elif ( type.Name == "ReentrantLock")
     ${an.body} = new ReentrantLock();   
          .elif ( default_value != "" )
     ${an.body} = ${default_value};   
          .end if
          .select one edt related by type->S_EDT[R17]
          .if ( not_empty edt )
            .invoke en = get_enumeration_class_name( type )
            .invoke default = GetEnumElementDefaultValueInfoString()
     ${an.body} = ${en.body}.${default.name};
          .end if
        .end for
        .if(unique_id_str != "")
    setUniqueId(${unique_id_str});
        .end if
        .if(key_result.found_key)
    Object [] key = ${key_result.key};
    addInstanceToMap(key);
        .end if
        .if (not_empty ism)
    // register with event queue poller
    Activepoller_c.register(this) ;
        .end if
  }

        .if(key_result.found_key)
  public Object getInstanceKey() {
    Object [] key =  ${key_result.key};
        return key;
  }
  
  public boolean setInstanceKey(UUID p_newKey){
  
    .invoke idResult = find_id(object)
    .assign object_id = idResult.id
    .select many id_attributes related by object_id->O_OIDA[R105]->O_ATTR[R105]
    boolean changed = false;
    .for each attr in id_attributes
        // round p1
        .invoke aip = attr_is_persistent(attr)
        // round p2
        .if(aip.result)
        // round p3
            .select one datatype related by attr->S_DT[R114]
            .assign type = datatype.Name
            .invoke gan = get_attribute_name ( attr )
            .assign attrName = gan.body
            .select one refAttr related by attr->O_RATTR[R106]
            .if(not_empty refAttr)
            // round p4
                .select one rtAttr related by refAttr->O_BATTR[R113]->O_ATTR[R106]
                .select one datatype related by rtAttr->S_DT[R114]
                .assign type = datatype.Name
            .end if
            .if(type == "unique_id")
            // round p5
    if (${attrName} !=  p_newKey ){
    
        ${attrName} = p_newKey;     
        changed = true;
    }
            .break for  
            .end if
            // round p6
        .end if
        // round p7
    .end for  
    return changed;
  }
  

  
        .end if

        .invoke gen_RGO_resolution = generate_RGO_resolve_methods(object)
${gen_RGO_resolution.body}\

        .if (not_empty ism)
  // Run Entry Point
  public boolean poll()
  {
      if (!eventQueue.isEmpty() || !selfEventQueue.isEmpty())
      { // an event queue is not empty
        procEvent() ;
        return true;
      } else {
        return false;
      }
  }
        .end if

  public boolean equals (Object elem) {
     if (!(elem instanceof ${class_name})) {
         return false;
     }
        // check that the model-roots are the same
        if (((NonRootModelElement)elem).getModelRoot() != getModelRoot() && !getModelRoot().isCompareRoot()) {
            return false;
        }
        
     return identityEquals(elem);
  }
  
   public boolean identityEquals(Object elem) {
       if (!(elem instanceof ${class_name})) {
           return false;
       }
       
       ${class_name} me = (${class_name})elem;
        .invoke id_result = find_id(object)
        .assign id = id_result.id
        .select many id_attrs related by id->O_OIDA[R105]->O_ATTR[R105]
        .for each id_attr in id_attrs
          .invoke aa = get_attribute_accessor( id_attr )
          .assign selfIdGetter = aa.body 
          .assign elemIdGetter = "((${class_name})elem).${selfIdGetter}"
          .assign attribute = id_attr
          .select one dt related by id_attr->S_DT[R114];
          .select any referential related by id_attr->O_RATTR[R106]; 
          .select one refDt related by referential->O_BATTR[R113]->O_ATTR[R106]->S_DT[R114]
          .assign isString = dt.Name == "string"
          .if(not isString)
            .if(not_empty refDt)
              .assign isString = refDt.Name == "string"
            .end if
          .end if
          .invoke ibaaui = is_base_attribute_a_unique_id(attribute)
          .if (ibaaui.is_unique_id)
      // don't allow an empty id-value to produce a false positive result;
      // in this case, use whether the two instances are actually the same 
      // one in memory, instead
      if (!getModelRoot().isCompareRoot() && ((IdAssigner.NULL_UUID.equals(${selfIdGetter}()) || IdAssigner.NULL_UUID.equals(${elemIdGetter}())) && this != elem)) {
        return false;
      }
      if (!${selfIdGetter}().equals(${elemIdGetter}())) return false;
          .elif(isString)
      if (!${selfIdGetter}().equals(${elemIdGetter}())) return false;    
          .else
      if (${selfIdGetter}() != ${elemIdGetter}()) return false;
          .end if
        .end for
      return true;
    }

   public boolean cachedIdentityEquals(Object elem) {
       if (!(elem instanceof ${class_name})) {
           return false;
       }
       
       ${class_name} me = (${class_name})elem;
        .invoke id_result = find_id(object)
        .assign id = id_result.id
        .select many id_attrs related by id->O_OIDA[R105]->O_ATTR[R105]
        .for each id_attr in id_attrs
          .select any referential related by id_attr->O_RATTR[R106]; 
          .invoke aa = get_attribute_accessor( id_attr )
          .assign selfIdGetter = aa.body + "CachedValue"
          .if(empty referential)
            .// do not use the cache text
            .assign selfIdGetter = aa.body;
          .end if 
          .assign elemIdGetter = "((${class_name})elem).${selfIdGetter}"
          .assign attribute = id_attr
          .select one dt related by id_attr->S_DT[R114]
          .select one refDt related by referential->O_BATTR[R113]->O_ATTR[R106]->S_DT[R114]
          .assign isString = dt.Name == "string"
          .if(not isString)
            .if(not_empty refDt)
              .assign isString = refDt.Name == "string"
            .end if
          .end if
          .invoke ibaaui = is_base_attribute_a_unique_id(attribute)
          .if (ibaaui.is_unique_id)
      if (!${selfIdGetter}().equals(${elemIdGetter}())) return false;
          .elif(isString)
      if (!${selfIdGetter}().equals(${elemIdGetter}())) return false;   
          .else
      if (${selfIdGetter}() != ${elemIdGetter}()) return false;
          .end if
        .end for
      return true;
    }


  // Attributes
        .select many attributes related by object->O_ATTR[R102]
        .for each attribute in attributes
          .if (attribute.Name != "current_state")
            .select one type related by attribute->S_DT[R114]
            .select any referential related by attribute->O_RATTR[R106]
            .if (not_empty referential)
              .select one type related by referential->O_BATTR[R113]->O_ATTR[R106]->S_DT[R114]
            .end if
            .invoke typedecl = do_type(type)
            .invoke an = get_attribute_name( attribute )
  private ${typedecl.body} ${an.body} ;
            .invoke ibaaui = is_base_attribute_a_unique_id(attribute)
            .invoke iref = is_referential_attr(attribute)
            .if ((ibaaui.is_unique_id) and (not iref.result))
  private long ${an.body}LongBased ;
            .end if
          .end if
        .end for
        .select many references related by object->R_OIR[R201]->R_RGO[R203]
        .if (not_empty references)
      
// declare association references from this class
  
          .for each reference in references
            .invoke ref = xlate_referring_objects(reference, package)
  ${ref.body}
          .end for
        .end if
        .//
        .select many referees related by object->R_OIR[R201]->R_RTO[R203]
        .if (not_empty referees)

// declare associations referring to this class

          .for each referee in referees
            .invoke ref = xlate_referred_to_objects(referee, package)
  ${ref.body}
          .end for
        .end if
        .//
      
        .select many ref_rel_set related by object->R_OIR[R201]->R_RGO[R203]
  public void batchRelate(ModelRoot modelRoot, boolean notifyChanges, boolean searchAllRoots)
  {
      batchRelate(modelRoot, false, notifyChanges, searchAllRoots);
  }
  
  public void batchRelate(ModelRoot modelRoot, boolean relateProxies, boolean notifyChanges, boolean searchAllRoots)
  {
        .assign rto_ref_var_name = ""
        .if ( not_empty ref_rel_set )
        InstanceList instances=null;
        ModelRoot baseRoot = modelRoot;
          .for each ref_rel in ref_rel_set
            .select any frm_ref_end related by ref_rel->R_FORM[R205]
            .assign notAlreadyRelatedTest = ""
            .if (not_empty frm_ref_end)
              .select any spc_rel related by frm_ref_end->R_SIMP[R208]
              .select any tar_rel_end related by spc_rel->R_PART[R207]
              .select any rto related by tar_rel_end->R_RTO[R204]
              .select any tar_obj related by rto->R_OIR[R203]->O_OBJ[R201]
              .assign tar_txt_phrs = "${tar_rel_end.Txt_Phrs}"
              .invoke grvn = get_referential_var_name( tar_obj, tar_txt_phrs )
              .assign ref_var_name = "${grvn.body}"
              .assign rto_ref_var_name = ref_var_name
              .assign notAlreadyRelatedTest = "${grvn.body} == null || ${grvn.body}.isProxy()"
    if (${notAlreadyRelatedTest}) {          
            .end if
            .select one rel related by ref_rel->R_OIR[R203]->R_REL[R201]
            .select many rto_set related by rel->R_OIR[R201]->R_RTO[R203]
      // R${rel.Numb}
            .assign rto_index = 0
            .for each rto in rto_set
              .assign rto_index = rto_index + 1
              .select one rto_obj related by rto->R_OIR[R203]->O_OBJ[R201]
              .invoke rcn = get_class_name( rto_obj )
              .invoke guk = get_unique_instance_key_from_rto(object, rto)
              .assign rel_inst_var_name = "relInst${rto_obj.Key_Lett}${rel.Numb}_${rto_index}"
              .if ("${rto_obj.Descrip:PEI}" == "true")
      baseRoot = ${package.application_root_class}.getDefaultInstance();
      if(baseRoot != modelRoot && modelRoot.isCompareRoot()) {
        baseRoot = modelRoot; 
      }
              .end if
              .if(not guk.found_key)
      instances = baseRoot.getInstanceList(${rcn.body}.class);
      ${rcn.body} ${rel_inst_var_name} = null;
      synchronized(instances) {
        Iterator<NonRootModelElement> cursor = instances.iterator() ;
        while (cursor.hasNext())
        {
           ${rcn.body} source = (${rcn.body})cursor.next() ;
           if (\
                .select many rtida_set related by rto->O_RTIDA[R110]
                .for each rtida in rtida_set
                  .select one idAttr related by rtida->O_OIDA[R110]->O_ATTR[R105]
                  .// we need a where clause here for subtype supertype
                  .// (multiple ref attrs map to one id attr)
                  .select any refAttr related by rtida->O_REF[R111]->O_RATTR[R108]->O_ATTR[R106] where ( selected.Obj_ID == object.Obj_ID )
                  .invoke idaaa = get_attribute_accessor( idAttr )
                  .select one idrefattr related by idAttr->O_RATTR[R106]
                  .assign value_str = ""
                  .if ( not_empty idrefattr )
                    .assign value_str = "CachedValue"
                  .end if
                  .invoke refan = get_attribute_name( refAttr )
                  .invoke ibaaui = is_base_attribute_a_unique_id(idAttr)
                  .if(ibaaui.is_unique_id)
     source.${idaaa.body}${value_str}().equals(${refan.body}) \
                  .else
     source.${idaaa.body}${value_str}() == ${refan.body} \
                  .end if
                  .if ( not_last rtida_set )
&& 
                  .end if
                .end for
        ){
        ${rel_inst_var_name} = source;
            break;
          }
      }
     }//synchronized
              .else
      ${rcn.body} ${rel_inst_var_name} = (${rcn.body}) baseRoot.getInstanceList(${rcn.body}.class).get(new Object[] ${guk.key});
            // if there was no local element, check for any global elements
            // failing that proceed to check other model roots
            if (${rel_inst_var_name} == null) {
                ${rel_inst_var_name} = (${rcn.body}) Ooaofooa.getDefaultInstance().getInstanceList(${rcn.body}.class).get(new Object[] ${guk.key});
            }
                .assign search_all_model_roots = package.search_all_model_roots
                .if(search_all_model_roots)
            if (${rel_inst_var_name} == null && searchAllRoots && !baseRoot.isCompareRoot()) {
                ${application_root_class}[] roots = ${application_root_class}.getInstances();
                for (int i = 0; i < roots.length; i++) {
                    if(roots[i].isCompareRoot()) {
                         // never use elements from any compare root
                         continue;
                    }
                    ${rel_inst_var_name} = (${rcn.body}) roots[i].getInstanceList(${rcn.body}.class).get(new Object[] ${guk.key});
                  .if((not_empty frm_ref_end) and ("${rto_ref_var_name}" != ""))
					if (${rel_inst_var_name} != null) {
						if (!${rel_inst_var_name}.isProxy() && ${rto_ref_var_name} != null) {
							// relate to the non proxy element if the current referred to
							// is a proxy and we are not
							if (!isProxy()) {
								if (${rto_ref_var_name}.isProxy()) {
									break;
								}
							}
						} else {
							if (${rto_ref_var_name} == null)
								// relate to the found proxy (initial batch relate)
								break;
						}
					}
                  .else
                    if (${rel_inst_var_name} != null)
                    	break;
                  .end if
                }
            }
                .end if
              .end if
            //synchronized
      if ( ${rel_inst_var_name} != null ) 
      {
              .invoke grf = get_reflexive_phrase( rel, rto, false )
              .assign func_suffix = grf.result
              .if ( package.is_eclipse_plugin )
          if (relateProxies || !isProxy() || (inSameComponent(this, ${rel_inst_var_name}) && !isProxy())) {
              .end if
          ${rel_inst_var_name}.relateAcrossR${rel.Numb}To${func_suffix}(this, notifyChanges);
              .if ( package.is_eclipse_plugin )
      }
              .end if
              .if ((package.is_root) and ("${rto_obj.Key_Lett}" == "S_SYS"))
          // set the root in the Domain's model root, not the System Model's
          // modelRoot is the SystemModel's root when we are loading a Domain proxy
          ((Ooaofooa)getModelRoot()).setRoot(${rel_inst_var_name});
              .end if
      }
              .if ("${rto_obj.Descrip:PEI}" == "true")
          baseRoot = modelRoot;
              .end if
              .if (notAlreadyRelatedTest != "")
    }
              .end if
              
            .end for
          .end for
        .end if
    }
  public void batchUnrelate(boolean notifyChanges)
  {
        .if ( not_empty ref_rel_set )
        NonRootModelElement inst=null;
          .for each ref_rel in ref_rel_set
            .select one rel related by ref_rel->R_OIR[R203]->R_REL[R201]
            .select many rto_set related by rel->R_OIR[R201]->R_RTO[R203]
      // R${rel.Numb}
            .for each rto in rto_set
              .select one rto_obj related by rto->R_OIR[R203]->O_OBJ[R201]
      // ${rto_obj.Key_Lett}
              .assign phrase = ""
              .select one part related by rto->R_PART[R204]
              .if (not_empty part )
                .assign phrase = "${part.Txt_Phrs}"
              .end if
              .select one aone related by rto->R_AONE[R204]
              .if (not_empty aone )
                .assign phrase = "${aone.Txt_Phrs}"
              .end if
              .select one aoth related by rto->R_AOTH[R204]
              .if (not_empty aoth )
                .assign phrase = "${aoth.Txt_Phrs}"
              .end if
              .select one super related by rto->R_SUPER[R204]
              .if (not_empty super )
                .assign phrase = "Is Supertype"
              .end if
          inst=$cr{phrase}$cr{rto_obj.Name};
              .invoke grf = get_reflexive_phrase( rel, rto, true )
              .assign func_suffix = grf.result
            unrelateAcrossR${rel.Numb}From${func_suffix}($cr{phrase}$cr{rto_obj.Name}, notifyChanges);
              .if ( package.is_eclipse_plugin )
          if ( inst != null ) {
               inst.removeRef();
          }
              .end if
            .end for
          .end for
        .end if
    }
  public static void batchRelateAll(ModelRoot modelRoot, boolean notifyChanges, boolean searchAllRoots) {
        batchRelateAll(modelRoot, notifyChanges, searchAllRoots, false);
  }   
  public static void batchRelateAll(ModelRoot modelRoot, boolean notifyChanges, boolean searchAllRoots, boolean relateProxies)
  {
        .if ( not_empty ref_rel_set )
    InstanceList instances = modelRoot.getInstanceList(${class_name}.class);
    synchronized(instances) {
        Iterator<NonRootModelElement> cursor = instances.iterator() ;
        while (cursor.hasNext())
        {
            final ${class_name} inst = (${class_name})cursor.next() ;
            inst.batchRelate(modelRoot, relateProxies, notifyChanges, searchAllRoots );
        }
    }
        .else
        
      // class has no referential attributes
  
        .end if   .// if not_empty ref_rel_set
  }

  public static void clearInstances(ModelRoot modelRoot)
  {
    InstanceList instances = modelRoot.getInstanceList(${class_name}.class);
    synchronized(instances) {
       for(int i=instances.size()-1; i>=0; i--){
              ((NonRootModelElement)instances.get(i)).delete_unchecked();
       }
    
    }
  }

  public static ${class_name} $cr{object.Name}Instance(ModelRoot modelRoot, ${tcn.body} test, boolean loadComponent) {
    InstanceList instances = modelRoot.getInstanceList(${class_name}.class);
    synchronized (instances) {
      for (int i = 0; i < instances.size(); ++i) {
        ${class_name} x = (${class_name}) instances.get(i);
        if (test==null || test.evaluate(x)){
          return x;
        }
      }
    }
    return null;
  }
  public static ${class_name} $cr{object.Name}Instance(ModelRoot modelRoot, ${tcn.body} test){
     return $cr{object.Name}Instance(modelRoot,test,true);
  }
  
  public static ${class_name} $cr{object.Name}Instance(ModelRoot modelRoot)
  {
     return $cr{object.Name}Instance(modelRoot,null,true);
  }

  public static ${class_name} [] $cr{object.Name}Instances(ModelRoot modelRoot, ${tcn.body} test, boolean loadComponent)
  { 
            InstanceList instances = modelRoot.getInstanceList(${class_name}.class);
            Vector matches = new Vector();
            synchronized (instances) {
                for (int i = 0; i < instances.size(); ++i) {
                    ${class_name} x = (${class_name}) instances.get(i);
                    if (test==null ||test.evaluate(x)){
                        matches.add(x);
                }
                }
            if (matches.size() > 0) {
                ${class_name}[] ret_set = new ${class_name}[matches.size()];
                matches.copyInto(ret_set);
                return ret_set;
            } else {
                return new ${class_name}[0];
            }       
        } 
  }
  public static ${class_name} [] $cr{object.Name}Instances(ModelRoot modelRoot, ${tcn.body} test){
    return  $cr{object.Name}Instances(modelRoot,test,true);
  }
  public static ${class_name} [] $cr{object.Name}Instances(ModelRoot modelRoot)
  {
    return $cr{object.Name}Instances(modelRoot,null,true);
  }

        .select any ism related by object->SM_ISM[R518]
  public boolean delete()
  {
    boolean result = super.delete();
        .if (not_empty ism)
    Activepoller_c.unRegister(this) ;
        .end if      
    boolean delete_error = false;
    String errorMsg = "The following relationships were not torn down by the ${object.Name}.dispose call: ";
        .select many rels related by object->R_OIR[R201]->R_REL[R201]
        .for each rel in rels
          .assign printcode = ""
          .assign delete_check_boolean = "delete_error = true;"
          .// simple association tests
          .select one simp related by rel->R_SIMP[R206]
          .if(not_empty simp)
            .select one part related by simp->R_PART[R207]
            .select one form related by simp->R_FORM[R208]
            .select one part_obj related by part->R_RTO[R204]->R_OIR[R203]->O_OBJ[R201]
            .select one form_obj related by form->R_RGO[R205]->R_OIR[R203]->O_OBJ[R201]
            .assign phrase = ""
            .assign class_type = ""
            .if(part_obj == object)
              .invoke gnfn = get_nav_func_name( form_obj, rel, "one" )
              .invoke fcn = get_class_name( form_obj )
              .assign class_type = fcn.body
              .if(part_obj == form_obj)
                .// reflexive association
                .assign phrase = form.Txt_Phrs
              .end if
    ${class_type} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}
    errorMsg = errorMsg + "${rel.Numb} ";   
    }
            .end if
            .if(form_obj == object)
              .invoke gnfn = get_nav_func_name( part_obj, rel, "one" )
              .invoke fcn = get_class_name( part_obj )
              .assign class_type = fcn.body
              .if(part_obj == form_obj)
                .// reflexive association
                .assign phrase = part.Txt_Phrs
                .// we processed the part from the reflexive
                .// now set class name to none so there
                .// are no duplicate variables
                .assign class_type = ""
              .end if
    ${class_type} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}         
    errorMsg = errorMsg + "${rel.Numb} ";
    }
            .end if
          .end if
          .// end simple association tests
          .// linked association tests
          .select one assoc related by rel->R_ASSOC[R206]
          .if(not_empty assoc)
            .select one aone related by assoc->R_AONE[R209]
            .select one aoth related by assoc->R_AOTH[R210]
            .select one assr related by assoc->R_ASSR[R211]
            .select one aone_obj related by aone->R_RTO[R204]->R_OIR[R203]->O_OBJ[R201]
            .select one aoth_obj related by aoth->R_RTO[R204]->R_OIR[R203]->O_OBJ[R201]
            .select one assr_obj related by assr->R_RGO[R205]->R_OIR[R203]->O_OBJ[R201]
            .assign phrase = ""
            .assign class_type = ""
            .if(aone_obj == object)
              .invoke gnfn = get_nav_func_name( assr_obj, rel, "one" )
              .invoke fcn = get_class_name( assr_obj )
              .assign class_type = fcn.body
              .if(aone.Obj_ID == aoth.Obj_ID)
                .// reflexive association
                .assign phrase = aoth.Txt_Phrs
              .end if
    ${class_type} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}         
    errorMsg = errorMsg + "${rel.Numb} ";
    }
            .end if
            .if(aoth_obj == object)
              .invoke gnfn = get_nav_func_name( assr_obj, rel, "one" )
              .invoke fcn = get_class_name( assr_obj )
              .assign class_type = fcn.body
              .if(aone.Obj_ID == aoth.Obj_ID)
                .// reflexive association
                .assign phrase = aone.Txt_Phrs
                .// we processed the aone from the reflexive
                .// now set class name to none so there
                .// are no duplicate variables
                .assign class_type = ""
              .end if
    ${class_type} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}
    errorMsg = errorMsg + "${rel.Numb} ";
    }
            .end if
            .if(assr_obj == object)
              .assign phrase_one = ""
              .assign phrase_oth = ""
              .invoke gnfn = get_nav_func_name( aone_obj, rel, "one" )
              .invoke fcn = get_class_name( aone_obj )
              .if(aone.Obj_ID == aoth.Obj_ID)
                .assign phrase_one = aone.Txt_Phrs
                .assign phrase_oth = aoth.Txt_Phrs
              .end if
              .invoke gnfn_aoth = get_nav_func_name( aoth_obj, rel, "one" )
              .invoke fcn_aoth = get_class_name( aoth_obj )
    ${fcn.body} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase_one}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}         
    errorMsg = errorMsg + "${rel.Numb} ";   
    }

   ${fcn_aoth.body} testR${rel.Numb}InstOth = ${fcn_aoth.body}.${gnfn_aoth.body}$cr{phrase_oth}(this, false);

   if ( testR${rel.Numb}InstOth != null )
   {
   ${delete_check_boolean}
   errorMsg = errorMsg + "${rel.Numb} ";   
    }           
            .end if
          .end if
          .// end linked association tests
          .// Subtype/Supertype tests
          .select one subsup related by rel->R_SUBSUP[R206]
          .if(not_empty subsup)
            .select one super related by subsup->R_SUPER[R212]
            .select many subs related by subsup->R_SUB[R213]
            .select one super_obj related by super->R_RTO[R204]->R_OIR[R203]->O_OBJ[R201]
            .assign sub_count = 0 
            .for each sub in subs
              .assign sub_count = sub_count + 1
              .select one sub_obj related by sub->R_RGO[R205]->R_OIR[R203]->O_OBJ[R201]
              .if(super_obj == object)
                .invoke gnfn = get_nav_func_name( sub_obj, rel, "one" )
                .invoke fcn = get_class_name( sub_obj )
    ${fcn.body} testR${rel.Numb}Inst${sub_count} = ${fcn.body}.${gnfn.body}(this, false);

    if ( testR${rel.Numb}Inst${sub_count} != null )
    {
    ${delete_check_boolean}
    errorMsg = errorMsg + "${rel.Numb} ";
    }
              .end if
              .if(sub_obj == object)
                .invoke gnfn = get_nav_func_name( super_obj, rel, "one" )
                .invoke fcn = get_class_name( super_obj )
    ${fcn.body} testR${rel.Numb}Inst${sub_count} = ${fcn.body}.${gnfn.body}(this, false);

    if ( testR${rel.Numb}Inst${sub_count} != null )
    {
    ${delete_check_boolean}         
    errorMsg = errorMsg + "${rel.Numb} ";
    }
              .end if
            .end for
          .end if
          .// end Subtype/Supertype tests
          .// Composition Association tests
          .select one comp related by rel->R_COMP[R206]
          .if(not_empty comp)
            .select one cone related by comp->R_CONE[R214]
            .select one coth related by comp->R_COTH[R215]
            .select one cone_obj related by cone->R_OIR[R203]->O_OBJ[R201]
            .select one coth_obj related by coth->R_OIR[R203]->O_OBJ[R201]
            .assign phrase = ""
            .assign class_type = ""
            .if(cone_obj == object)
              .invoke gnfn = get_nav_func_name( coth_obj, rel, "one" )
              .invoke fcn = get_class_name( coth_obj )
              .assign class_type = fcn.body
              .if(cone_obj == coth_obj)
                .// reflexive association
                .assign phrase = coth.Txt_Phrs
              .end if
    ${class_type} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}
    errorMsg = errorMsg + "${rel.Numb} ";       
    }         
            .end if
            .if(coth_obj == object)
              .invoke gnfn = get_nav_func_name( coth_obj, rel, "one" )
              .invoke fcn = get_class_name( coth_obj )
              .assign class_type = fcn.body
              .if(cone_obj == coth_obj)
                .// reflexive association
                .assign phrase = cone.Txt_Phrs
                .// we processed the cone from the reflexive
                .// now set class name to none so there
                .// are no duplicate variables
                .assign class_type = ""
              .end if
    ${class_type} testR${rel.Numb}Inst = ${fcn.body}.${gnfn.body}$cr{phrase}(this, false);

    if ( testR${rel.Numb}Inst != null )
    {
    ${delete_check_boolean}
    errorMsg = errorMsg + "${rel.Numb} ";
    }                 
            .end if
          .end if
          .// end Composition Association tests
        .end for
    if(delete_error == true) {

        .if(package.is_eclipse_plugin)
        if(${package.plugin_classname}.getDefault().isDebugging()) {
            ${package.application_root_class}.log.println(ILogger.DELETE, "${object.Name}", errorMsg);
        }
        else {
            Exception e = new Exception();
            e.fillInStackTrace();
            ${package.plugin_classname}.logError(errorMsg, e);
        }
        .else
        System.out.println(errorMsg);
        .end if
    }
    return result;
  }

        .invoke hia = has_id_assigner( attributes )
        .if ( hia.result )
    /**
     * Assigns IDs to instances of this class.
     */
    private static IdAssigner idAssigner = new IdAssigner(${class_name}.class.getName());
    
    /**
     * See field.
     */
    public IdAssigner getIdAssigner() {return idAssigner;}

    /**
     * See field.
     */
    public static IdAssigner getIdAssigner_() {return idAssigner;}
        .end if
  // end declare instance pool

  // declare attribute accessors
        .if (not_empty attributes)
  public boolean isUUID(String attributeName){
          .for each attribute in attributes
            .invoke result = is_base_attribute_a_unique_id(attribute)
            .if(result.is_unique_id)
      if(attributeName.equals("$l_{attribute.Name}")){
         return true;
      }
            .end if
          .end for
      return false;      
  }      
          .if(package.is_root AND persistent)
            .invoke id_result = find_id(object)
            .assign id = id_result.id
            .select many id_attrs related by id->O_OIDA[R105]->O_ATTR[R105]
            .if(not_empty id_attrs)
 public String getCompUniqueID(){
    UUID tempID=null;
    long longID=0L;
    StringBuffer result= new StringBuffer();
    
              .for each id_attr in id_attrs
                .invoke aa = get_attribute_accessor(id_attr)
                .invoke result = get_base_attribute_type( id_attr )
                .assign type = result.type
                .invoke check_primitive_java = is_java_primitive_type(type)
                .if (not check_primitive_java.isPrimitive)       
    tempID= ${aa.body}();
                .else
    longID= ${aa.body}();
                .end if
                .select any referential related by id_attr->O_RATTR[R106]
    
                .if(not_empty referential)
                  .if (not check_primitive_java.isPrimitive) 
        if(IdAssigner.NULL_UUID.equals(tempID))
          tempID=${aa.body}CachedValue(); 
                  .else
                    .// special case of Oid_ID as the value
                    .// will be -1 if not associated with ClassIdentifier
                    .if(id_attr.Name == "Oid_ID")
        if(longID == -1)
                    .else
        if(longID==0L)
                    .end if
          longID=${aa.body}CachedValue(); 
                  .end if    
                .end if
                .if (not check_primitive_java.isPrimitive) 
          result.append(Long.toHexString(tempID.getMostSignificantBits()));
          result.append(Long.toHexString(tempID.getLeastSignificantBits()));
                .else
          result.append(longID+"_");
                .end if     
              .end for
    return result.toString();
 }
            .end if
          .end if
  // declare attribute accessors
          .select many uniqueids from instances of O_ATTR where (selected.Attr_ID == -1)
          .assign foundSuperType = false 
          .for each attribute in attributes
            .if (attribute.Name != "current_state")
              .select one type related by attribute->S_DT[R114]
              .select any referential related by attribute->O_RATTR[R106]
              .if (not_empty referential)
                .select one type related by referential->O_BATTR[R113]->O_ATTR[R106]->S_DT[R114]
              .end if
              .invoke typedecl = do_type(type)
              .invoke aa = get_attribute_accessor( attribute )
              .invoke an1 = get_attribute_name( attribute )
              .select one dbattr related by attribute->O_BATTR[R106]->O_DBATTR[R107]
              .if ((empty dbattr) and (type.Name == "unique_id"))
                .if(empty referential)
  public long ${aa.body}LongBased()
  {
    if(${an1.body}LongBased == 0 && !IdAssigner.NULL_UUID.equals(${an1.body})){
        return 0xfffffff & ${an1.body}.getLeastSignificantBits();
    }
    return ${an1.body}LongBased ;
  }
                .else
  public long ${aa.body}LongBased()
  {
                  .select many oref_set related by referential->O_REF[R108]
                  .for each oref in oref_set
                    .invoke result = get_referential_var_name_of_rgo(oref)
                    .assign ref_var_name = result.var_name
                    .assign id_attr_accessor = result.id_attr_accessor
    if ( ${ref_var_name} != null )
    {
      return ${ref_var_name}.${id_attr_accessor}LongBased();
    }
                  .end for
    return 0;  
  }          
                .end if
              .end if
  public $r{typedecl.body} ${aa.body}()
  {
              .if ( empty dbattr )
                .if ( empty referential )
    return ${an1.body} ;
                .else
                  .// referential attribute
                  .select many oref_set related by referential->O_REF[R108]
                  .for each oref in oref_set
                    .invoke result = get_referential_var_name_of_rgo(oref)
                    .assign ref_var_name = result.var_name
                    .assign id_attr_accessor = result.id_attr_accessor
    if ( ${ref_var_name} != null )
    {
      if(getModelRoot().isCompareRoot()) {
          if(${ref_var_name}.isProxy()) {
              return $r{aa.body}CachedValue();
          }
      }
      return ${ref_var_name}.${id_attr_accessor}();
    }
                  .end for
                  .assign default_value = "${attribute.Descrip:Not_participating_value}"
                  .if (type.Name == "string")
    return "${default_value}";   
                  .elif ( type.Name == "unique_id" )
                    .select any superAssoc related by referential->O_REF[R108]->R_RGO[R111]->R_SUB[R205]->R_SUBSUP[R213]->R_REL[R206] where ("$l{selected.Descrip:Optional}" == "true")
                    .if (not_empty superAssoc)
    return ${an1.body} ; // Supertype existence is optional, just return the local cached referential value
                    .else
    return IdAssigner.NULL_UUID;
                    .end if
                  .elif ( default_value != "" )
    return ${default_value};
                  .else
    return 0;
                  .end if
                .end if
              .else
                .if ("${attribute.Descrip:Translate}" == "native")
                  .print "${attribute.Name} written as native code"
${dbattr.Action_Semantics}
                .else
                  .// Generate Action Language Code using Processing Subsystem Instances
                  .select any actionblock related by dbattr->ACT_DAB[R693]->ACT_ACT[R698]
                  .select any block related by actionblock->ACT_BLK[R666]
                  .invoke blck = blck_xlate(block)
ModelRoot modelRoot = getModelRoot();
${blck.body}
                .end if
              .end if
  }

              .if ( empty dbattr )
                .if ( not_empty referential )
                  .select many oref_set related by referential->O_REF[R108]
                  .for each oref in oref_set
                    .invoke result = get_referential_var_name_of_rgo_super_only(oref)
                    .assign ref_var_name = result.var_name
                    .assign id_attr_accessor = result.id_attr_accessor
                    .if ( ref_var_name != "unknown" )
                      .if ( foundSuperType == false )
                        .assign foundSuperType = true
 public boolean hasSuperType(){
    return  ( ${ref_var_name} != null );
 
 }                  
                      .end if
                    .end if   
                  .end for
                .end if
              .end if 

              .if ( not_empty referential )
  public $r{typedecl.body} ${aa.body}CachedValue()
  {
                .// generate a check to see if the attribute value is the one
                .// for non-participation (if such a value has been defined)
                .assign default_value = "${attribute.Descrip:Not_participating_value}"
                .assign checkReference = true
                .if (type.Name == "string")
    if ( !${an1.body}.equals("${default_value}") )
                .elif (type.Name == "unique_id")
    if ( !IdAssigner.NULL_UUID.equals(${an1.body}) )
                .elif ( default_value != "" )
    if ( ${an1.body} != ${default_value} )
                .else 
                  .assign checkReference = false
                .end if
                .// here's where we return the local attribute value, under
                .// normal circumstances
      return ${an1.body};
                .// this will get hit if the attribute value was found to be the
                .// one for non-participation; we return the corresponding 
                .// attribute value in the referred-to instance, instead;
                .// this lets calls to batchRelate work properly when the instances 
                .// were related using relateAcross.. methods (which do not copy 
                .// the attribute value into the referrer), rather than by 
                .// supplying ID's to the persistence-oriented constructors
                .if (checkReference)
    else
      return ${aa.body}();
                .end if
  }
  
              .end if
              .invoke iuia = is_uniqueid_id_attr(attribute)
              .// if this attribute is of the type unique_id
              .// add it to the collection of unique ids for
              .// this class
              .if((iuia.result) and (empty referential))
                .assign uniqueids = uniqueids | attribute     
              .end if
              .select many tmp_oref_set related by referential->O_REF[R108]
              .assign oref_cnt = cardinality tmp_oref_set
              .if (empty dbattr)
                .// if the current attribute is of the type
                .// unique_id then we make this set method
                .// private
  public void set$cr{attribute.Name}($r{typedecl.body} newValue)
  {
                .invoke prop_delta = notifies_changes(attribute, "O_ATTR")
                .if ((package.is_eclipse_plugin AND prop_delta.result) and (not iuia.result))
                  .if ( type.Name == "instance" )
                    .// special case -- The "instance" type should be compared using ==, but send the
                    .// instance in the model change delta
    if(${an1.body} == newValue){
        return;
    }
    AttributeChangeModelDelta change = new AttributeChangeModelDelta(Modeleventnotification_c.DELTA_ATTRIBUTE_CHANGE, this, "$cr{attribute.Name}", ${an1.body}, newValue,$l{persistent}); 
                  .else                
                    .invoke check_primitive_java = is_java_primitive_type(type)
                    .if (check_primitive_java.isPrimitive)
                      .invoke java_type = get_java_wrapper_type(type)
    if(${an1.body} == newValue){
        return;
    }
    AttributeChangeModelDelta change = new AttributeChangeModelDelta(Modeleventnotification_c.DELTA_ATTRIBUTE_CHANGE, this, "$cr{attribute.Name}", new ${java_type.javaType}(${an1.body}), new ${java_type.javaType}(newValue),$l{persistent});

                      .// Since this is not a java primitve type, we dont need to send a 'new' warpper instance and hence we can send the object as it is
                    .else 
    if(newValue != null){
        if(newValue.equals(${an1.body})){
            return;
        }
    }else if(${an1.body} != null){
        if(${an1.body}.equals(newValue)){
            return;
        }
    }else{
        return;
    }
    AttributeChangeModelDelta change = new AttributeChangeModelDelta(Modeleventnotification_c.DELTA_ATTRIBUTE_CHANGE, this, "$cr{attribute.Name}", ${an1.body}, newValue,$l{persistent}); 
                    .end if  .// isPrimitive
                  .end if  .// type.name == "instance"
                .end if   .// package....
                .invoke result = is_base_attribute_a_unique_id(attribute)
                .if(result.is_unique_id)
   ${an1.body} = IdAssigner.preprocessUUID(newValue);
                  .select many o_attrs related by attribute->O_OBJ[R102]->O_ATTR[R102]
                  .invoke unique_id_attr = get_unique_id_attr_id( o_attrs )
                  .if ( unique_id_attr.Attr_ID == attribute.Attr_ID )
   setUniqueId(${an1.body});
                  .end if
                .else
   ${an1.body} = newValue ;
                .end if
                .if ((package.is_eclipse_plugin and prop_delta.result) and (not iuia.result))
                  .if ((class_name == "SystemModel_c") and (attribute.Name == "Name"))              
        
        // for each model-root in existence
        ${application_root_class}[] modelRoots = ${application_root_class}.getInstances();
        for (int i = 0; i < modelRoots.length; i++) {
                    Package_c[] pkgs = Package_c.PackageInstances(modelRoots[i], null, false);
                    for(int j = 0; j < pkgs.length; j++) {
                        Package_c pkg = pkgs[j];
                        if(SystemModel_c.getOneS_SYSOnR1401(pkg) == this) {
                            ((Ooaofooa) (pkg.getModelRoot())).updateId(pkg.getName());
                        }
                    }
                    }
    
                  .end if
    ${package.application_root_class}.getDefaultInstance().fireModelElementAttributeChanged(change);
                .end if
  }
              .end if  .// empty dbattr
            .end if  .// attribute.Name != "current_state"
          .end for
  // end declare accessors
        .end if
 .//
        .invoke gccc = gen_class_consistency_checks( object, rpn_result.body, package )
${gccc.body}

.//  
        .select many transforms related by object->O_TFR[R115]
        .if (not_empty transforms)
  // declare transform functions
          .for each transform in transforms
            .select one ret_type related by transform->S_DT[R116]
            .assign synch = ""
            .assign synchronized = "${transform.Descrip:synchronized}"
            .if (synchronized == "true")
              .assign synch = "synchronized"
            .end if
            .invoke type = do_type(ret_type)
            .assign param_delimiter = ""
            .if (transform.Instance_Based == 1)
  public ${synch} ${type.body} $cr{transform.Name}(\
            .else
  public static ${type.body} $cr{transform.Name}(ModelRoot modelRoot\
              .assign param_delimiter = ","
            .end if
            .select many parameters related by transform->O_TPARM[R117]
            .invoke SortSetAlphabeticallyByNameAttr( parameters )
            .assign item_count = cardinality parameters
            .assign item_number = 0
            .while ( item_number < item_count )
              .for each parameter in parameters
                .if ( parameter.Order == item_number )
                  .select one par_type related by parameter->S_DT[R118]
                  .invoke type = do_type(par_type)
${param_delimiter}final ${type.body} p_$cr{parameter.Name}\
                  .assign param_delimiter = ","
                  .break for
                .end if
              .end for
              .assign item_number = item_number + 1
            .end while
)
  {
      ${package.application_root_class}.log.println(ILogger.OPERATION, "${object.Name}", " Operation entered: $cr{object.Name}::$cr{transform.Name}") ; 
            .if ("${transform.Descrip:Translate}" == "native")
              .print "${transform.Name} written as native code"
${transform.Action_Semantics}
            .else
              .if (transform.Instance_Based == 1)
               final ModelRoot modelRoot = getModelRoot();
              .end if
              .// Generate Action Language Code using Processing Subsystem Instances
              .select one actionblock related by transform->ACT_OPB[R696]->ACT_ACT[R698]
              .select any block related by actionblock->ACT_BLK[R666]
              .invoke blck = blck_xlate(block)
${blck.body}
            .end if
   } // End ${transform.Name}
          .end for

  // end transform functions

        .end if
        .// not_empty transforms
        .select one ism related by object->SM_ISM[R518]
        .if (not_empty ism)
          .select one sm related by ism->SM_SM[R517]
          .invoke gsm = generate_state_machine( object, sm, package, "", "" )
${gsm.body}\
        .end if 

        .select any filterOp related by object->O_TFR[R115] where (selected.Name == "actionFilter")
        .if (package.is_eclipse_plugin)
  public Object getAdapter(Class adapter) {
    Object superAdapter = super.getAdapter(adapter);
    if(superAdapter != null) {
        return superAdapter;
    }
          .if ( not_empty filterOp )
    if (adapter == IActionFilter.class)
    {
            .invoke gafcn = get_action_filter_class_name(object)
        return ${gafcn.body}.getSingleton();
    }
          .end if
          .if ( object.AdapterName == "IFile" )
    if (adapter == org.eclipse.core.resources.IResource.class) {
        PersistableModelComponent comp = getPersistableComponent(false);
        if ( comp != null )
        {
            return comp.getFile().getParent();
        }
    }else if(adapter == org.eclipse.core.resources.IFile.class) {
        PersistableModelComponent comp = getPersistableComponent(false);
        if ( comp != null )
        {
            return comp.getFile();
        }
    }
          .end if
          .if ( object.AdapterName == "IProject" )
    if (adapter == org.eclipse.core.resources.IResource.class
        || adapter == org.eclipse.core.resources.IProject.class) {
        IProject[] project_set = CorePlugin.getWorkspace().getRoot().getProjects();
        for (int i = 0; i < project_set.length; ++i) {
            if (XtUMLNature.hasNature(project_set[i])) {
                if (project_set[i].getName().equals(getName())) {
                    return project_set[i];  
                }
            }
        }
    } else if (adapter == org.eclipse.core.resources.IFile.class) {
        return getFile();
    } 
              .end if
      return null;
  }
        .end if   .// eclipse plugin
} // end ${object.Name}
        .emit to file "${project_root}/${package.location}/${class_name}.java"
        .//
        .if ( package.is_eclipse_plugin and (not_empty filterOp) )
package ${package.name} ;
          .invoke gafcn = get_action_filter_class_name(object)
          .invoke gfh = get_file_header("${package.name}.${gafcn.body}.java")
${gfh.body}\
import org.eclipse.ui.IActionFilter;
import ${package.name}.${class_name};
import org.eclipse.core.resources.ProjectScope;
import org.osgi.service.prefs.Preferences;
import org.xtuml.bp.core.ui.preferences.BridgePointProjectPreferences;

public class ${gafcn.body} implements IActionFilter
{
    private static ${gafcn.body} singleton;

    public static ${gafcn.body} getSingleton()
    {
        if (singleton == null)
            singleton = new ${gafcn.body}();
        return singleton;
    }

    /* (non-Javadoc)
     * @see org.eclipse.ui.IActionFilter#testAttribute(java.lang.Object, java.lang.String, java.lang.String)
     */
    public boolean testAttribute(Object target, String name, String value)
    {
        ${class_name} x = (${class_name}) target;
		if (name.equals("project_preference")) {
			final Preferences projectPrefs = new ProjectScope(x.getPersistableComponent().getFile().getProject())
					..getNode(BridgePointProjectPreferences.BP_PROJECT_PREFERENCES_ID);
			return value.split("=")[1].equals(projectPrefs.get(value.split("=")[0], null));
		} else {
        	return x.Actionfilter( name, value); 
		}
 
    }

}
          .emit to file "${project_root}/${package.location}/${gafcn.body}.java"
        .end if
        .//
        .select one asm related by object->SM_ASM[R519]
        .if (not_empty asm)
package ${package.name} ;
          .invoke gfh = get_file_header("${package.name}.$cr{object.Name}_assgner_c.java")
${gfh.body}\

import java.util.* ;

          .select one sm related by asm->SM_SM[R517]
          .select many events related by sm->SM_EVT[R502]
          .print "Translating Assigner: ${object.Name}"
          .invoke gec = generate_event_classes( object, events, "_CLASS" )
${gec.body}\

public class $cr{object.Name}_assgner_c extends Thread
{
  public $cr{object.Name}_assgner_c ()
  {
    start() ;
  }
  // Run Entry Point
  public void run()
  {
    do
    {
      if (!eventQueue.isEmpty() || !selfEventQueue.isEmpty())
      { // event queue not empty
        procEvent() ;
      }
      yield() ;
      //try{wait() ;} catch (Exception e){}     
    } while (true) ;
  }
  private static $cr{object.Name}_assgner_c instance = new $cr{object.Name}_assgner_c();
  
          .invoke gsm = generate_state_machine( object, sm, package, "_CLASS", "instance." )
${gsm.body}\

} // end ${object.Name}_assigner

          .emit to file "${project_root}/${package.location}/$cr{object.Name}_assgner_c.java"
        .end if
        .end if .// mc_class_only
      .end for
    .end if
  .end if .// if translate_enabled
.end for .// each package
.//
.//
.select any functions_pkg from instances of EP_PKG where (selected.Name == "Functions")
.invoke functions_in_split = in_split(functions_pkg, mc_pass_index)
.if ((not_empty splits) and (functions_in_split.result))
  .assign translate_enabled = true
.end if
.if (((translate_enabled == true) or (mc_ss_only != "")) and (mc_class_only == ""))
  .if (not already_translated)
    .// Translate OAL before translating the specifically requested package.
    .invoke translate_all_oal( mc_root_pkg, application_root_class, send_changes );
    .assign already_translated = true
  .end if
  .invoke gfh = get_file_header("${package.name}.${package.application_root_class}.java")
${gfh.body}\

package ${package.name};

  .if (package.is_eclipse_plugin)
    .if (package.is_root)
      .// Ooaofooa imports
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import org.eclipse.jface.preference.IPreferenceStore;

import org.xtuml.bp.core.util.UIUtil;
import org.eclipse.core.runtime.IProgressMonitor;
    .else
      .// Ooaofgraphics imports
import org.eclipse.core.runtime.IProgressMonitor;
import org.xtuml.bp.core.*;
    .end if
import org.xtuml.bp.core.common.*;
import org.xtuml.bp.core.util.*;
  .else
import java.util.Hashtable;
import java.util.Map;
import ${package.name}.common.*;
  .end if
/**
 * The model-root of the domain.  
 */
public class ${application_root_class} 
  .if (package.is_eclipse_plugin)
    .if (package.is_root)
    extends Eclipse${application_root_class}
    .else
    extends ${application_root_class}Base 
    .end if
  .else
    extends ModelRoot
  .end if
{
  .if ((package.is_eclipse_plugin) and (package.is_root))
  // To modify these counters the caller must first acquire
    // the appropriate semaphore.  These should not be directly 
    // manipulated, use the helper functions defined below.
    // These are used to prevent verifier execution during save operations
    // while allowing multiple saves or multiple verifier threads to run
  // concurrently.  In order to prevent multiple threads running against
  // the same Execution Engine at the same time, we keep a map of
  // currently running I_EXEs. Subsequent threads running against an 
  // already running I_EXE must wait until the former is finished.
    public static volatile int verifiersRunning = 0;
    public static Object verifiersRunningSemaphore = new Object();
    public static volatile int threadsSaving = 0;
    public static Object threadsSavingSemaphore = new Object();
  public static Map<UUID,Integer> verifiersRunningMap = new ConcurrentHashMap<UUID,Integer>();

    public static void beginSaveOperation() {
        synchronized (threadsSavingSemaphore) {
            if (threadsSaving == 0) {
                while (verifiersRunning > 0) {
                    try {
                        synchronized (verifiersRunningSemaphore) {
                            verifiersRunningSemaphore.wait();
                        }
                    } catch (InterruptedException e) {

                    }
                }
            }

            threadsSaving++;
        }
    }

    public static void endSaveOperation() {
        synchronized (threadsSavingSemaphore) {
            threadsSaving--;
            if (threadsSaving == 0) {
                threadsSavingSemaphore.notify();
            }
        }
    }

    public static void beginVerifierExecution(UUID engineID) {
        try {
        synchronized (verifiersRunningSemaphore) {
            if (verifiersRunning == 0) {
                while (threadsSaving > 0) {
                        synchronized (threadsSavingSemaphore) {
                            threadsSavingSemaphore.wait();
                        }
                    }
                }

                verifiersRunning++;
                        }

            synchronized (engineID) {
                if ( !verifiersRunningMap.containsKey(engineID) ) {
                    verifiersRunningMap.put(engineID, 0);
                } else {
                    if ( verifiersRunningMap.containsKey(engineID) ) {
                        engineID.wait();
                        verifiersRunningMap.put(engineID, 0);
                    }
                }
            }
        } catch (InterruptedException e) {
        }
    }

    public static void endVerifierExecution(UUID engineID) {
        synchronized (engineID) {
            verifiersRunningMap.remove(engineID);
            engineID.notify();
        }

        synchronized (verifiersRunningSemaphore) {
            verifiersRunning--;
            if (verifiersRunning == 0) {
                verifiersRunningSemaphore.notifyAll();
            }
        }
    }

  .end if
    protected ${application_root_class}(String aRootId)
    {
        super(aRootId);
  .if (not package.is_eclipse_plugin)
        log = new ${package.logger}Logger();
  .end if
    }

  public void clearDatabase(\
  .if (package.is_eclipse_plugin)
IProgressMonitor pm\
  .end if
)  
  {
  .select many total_class_set from instances of O_OBJ
  .select many pei_classes from instances of O_OBJ where ("${selected.Descrip:PEI}" == "true")
  .assign num_classes = ((cardinality total_class_set) - (cardinality pei_classes))
  .if (package.is_eclipse_plugin)
    pm.beginTask("Clearing database...", ${num_classes});
  .end if   
  .if (package.ui_root_class_name != "" )
    setRoot( null );
  .end if
  .select many class_set from instances of O_OBJ;
  .for each class in class_set
    .if ("${class.Descrip:PEI}" != "true")
      .invoke cn = get_class_name(class)
    ${cn.body}.clearInstances(this);
      .if (package.is_eclipse_plugin)
    pm.worked(1);
      .end if
    .end if
  .end for
    
  .if (package.is_eclipse_plugin)
    .if (package.is_root) 
        super.clearDatabase(pm);  
    .end if 
  .end if
  }
  //
  .invoke dom_cons = gen_dom_consistency_check( package )
${dom_cons.body}
  //
  // Domain level functions
  .select many pkgs related by root_pkg->PE_PE[R8000]->EP_PKG[R8001]
  .select many functions related by pkgs->PE_PE[R8000]->S_SYNC[R8001] where (("$U_{selected.Descrip:ContextMenuFunction}" != "TRUE") and ("$U_{selected.Descrip:ParserValidateFunction}" != "TRUE"))
  .while ( not_empty functions )
  .for each function in functions
    .select one ret_type related by function->S_DT[R25]
    .invoke type = do_type(ret_type)
  static public ${type.body} $cr{function.Name}(ModelRoot modelRoot\
    .select many parameters related by function->S_SPARM[R24]
    .invoke SortSetAlphabeticallyByNameAttr( parameters )
    .assign item_count = cardinality parameters
    .assign item_number = 0
    .while ( item_number < item_count )
      .for each parameter in parameters
        .if ( parameter.Order == item_number )
          .select one par_type related by parameter->S_DT[R26]
          .invoke type = do_type(par_type)
, final ${type.body} p_$cr{parameter.Name}\
          .break for
        .end if
      .end for
      .assign item_number = item_number + 1
    .end while
)
  {
      ${package.application_root_class}.log.println(ILogger.FUNCTION, "${function.Name}", " Function entered: $cr{function.Name}") ;  
    .if ("${function.Descrip:Translate}" == "native")
      .print "${function.Name} written as native code"
${function.Action_Semantics}
    .else
      .// Generate Action Language Code using Processing Subsystem Instances
      .print " Function ${function.Name}"
      .select any actionblock related by function->ACT_FNB[R695]->ACT_ACT[R698]
      .select any block related by actionblock->ACT_BLK[R666]
      .invoke blck = blck_xlate(block)
${blck.body}
    .end if
   }  // End ${function.Name}

  .end for
  .select many pkgs related by pkgs->PE_PE[R8000]->EP_PKG[R8001]
  .select many functions related by pkgs->PE_PE[R8000]->S_SYNC[R8001] where (("$U_{selected.Descrip:ContextMenuFunction}" != "TRUE") and ("$U_{selected.Descrip:ParserValidateFunction}" != "TRUE"))
  .end while
  // End Domain functions

    /**
     * The single model-root that used to be accessed by most of the code
     * back when only one domain could be loaded into the product at a time.
     * 
     * @deprecated  Since issue 684, all code should specifically identify 
     *              which instance of this class it seeks to retrieve, by 
     *              calling other access methods of this class like 
     *              getInstance(id).
     */
    protected static ${application_root_class} m_default_instance = null;

    public static ${application_root_class} getDefaultInstance() 
    {
        if (m_default_instance == null) {
            m_default_instance = getInstance(DEFAULT_WORKING_MODELSPACE);
        }
        return m_default_instance;
    }
    
    public static ${application_root_class} getInstance(String id) 
    {
        ${application_root_class} modelRoot = (${application_root_class}) rootInstanceMap.get(id);
        if (modelRoot == null) {
            modelRoot = new ${application_root_class}(id);
            if (DEFAULT_WORKING_MODELSPACE.equals(id)) {
                m_default_instance = modelRoot;
                init();
            }
        }
                
        return modelRoot;
    }

  .if ( not package.is_eclipse_plugin )
    protected static Map rootInstanceMap = new Hashtable();
  
  public static void main(String[] args)
  {
    // this will start it all off
      ${application_root_class}.getDefaultInstance();
  }
  
  .end if
    static private masterTimer_c m_myMasterTimer;
  .if (package.threading_model=="polling")  
    static private Activepoller_c m_myPoller ;

  .end if
  protected static void init()
  {

  .if (package.threading_model=="polling")  
    m_myPoller = new Activepoller_c() ;
    m_myPoller.start() ;

  .end if
    if(m_myMasterTimer != null){
        m_myMasterTimer = new masterTimer_c() ;
        m_myMasterTimer.start() ;
    }

  .include "${project_root}/color/$l{rpn_result.body}_startspec.clr"
  .invoke result = define_startspec()
  .if (result.init_class != "")
    .assign init_class_name = "${result.init_class}_c"
    ${init_class_name} ${result.init_var_name} = new ${init_class_name}() ;
  .end if
  .if (result.init_type == "event")
    ${result.init_var_name}.${result.init_stim}(false\
  .end if
  .if (result.init_type == "function")
    ${application_root_class}.${result.init_stim}(m_default_instance\
  .end if
  .if (result.parameter1 != "")
, ${result.parameter1} \
    .if (result.parameter2 != "")
, ${result.parameter2} \
    .end if
  .end if
  .if (result.init_type != "")
) ;
  .end if

  } /****** end init() ******/

  public static void shutdown()
  {
   if (m_myMasterTimer != null) {
       m_myMasterTimer.halt() ;
   }
  .if (package.threading_model=="polling")  
    if (m_myPoller != null) {
        m_myPoller.halt() ;
    }
  .end if
  }

}

  .emit to file "${project_root}/${package.location}/${application_root_class}.java"
.end if
