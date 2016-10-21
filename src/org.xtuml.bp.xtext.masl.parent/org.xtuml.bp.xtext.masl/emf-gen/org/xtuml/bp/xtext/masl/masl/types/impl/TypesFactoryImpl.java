/**
 * generated by Xtext 2.9.2
 */
package org.xtuml.bp.xtext.masl.masl.types.impl;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.impl.EFactoryImpl;

import org.eclipse.emf.ecore.plugin.EcorePlugin;

import org.xtuml.bp.xtext.masl.masl.types.*;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Factory</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class TypesFactoryImpl extends EFactoryImpl implements TypesFactory {
	/**
	 * Creates the default factory implementation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static TypesFactory init() {
		try {
			TypesFactory theTypesFactory = (TypesFactory)EPackage.Registry.INSTANCE.getEFactory(TypesPackage.eNS_URI);
			if (theTypesFactory != null) {
				return theTypesFactory;
			}
		}
		catch (Exception exception) {
			EcorePlugin.INSTANCE.log(exception);
		}
		return new TypesFactoryImpl();
	}

	/**
	 * Creates an instance of the factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TypesFactoryImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EObject create(EClass eClass) {
		switch (eClass.getClassifierID()) {
			case TypesPackage.TYPE_DECLARATION: return createTypeDeclaration();
			case TypesPackage.TYPE_FORWARD_DECLARATION: return createTypeForwardDeclaration();
			case TypesPackage.BUILTIN_TYPE_DECLARATION: return createBuiltinTypeDeclaration();
			case TypesPackage.TERMINATOR_TYPE_REFERENCE: return createTerminatorTypeReference();
			case TypesPackage.ABSTRACT_TYPE_DEFINITION: return createAbstractTypeDefinition();
			case TypesPackage.CONSTRAINED_TYPE_DEFINITION: return createConstrainedTypeDefinition();
			case TypesPackage.ABSTRACT_TYPE_CONSTRAINT: return createAbstractTypeConstraint();
			case TypesPackage.RANGE_CONSTRAINT: return createRangeConstraint();
			case TypesPackage.DELTA_CONSTRAINT: return createDeltaConstraint();
			case TypesPackage.DIGITS_CONSTRAINT: return createDigitsConstraint();
			case TypesPackage.STRUCTURE_TYPE_DEFINITION: return createStructureTypeDefinition();
			case TypesPackage.STRUCTURE_COMPONENT_DEFINITION: return createStructureComponentDefinition();
			case TypesPackage.ENUMERATION_TYPE_DEFINITION: return createEnumerationTypeDefinition();
			case TypesPackage.ENUMERATOR: return createEnumerator();
			case TypesPackage.UNCONSTRAINED_ARRAY_DEFINITION: return createUnconstrainedArrayDefinition();
			case TypesPackage.ABSTRACT_TYPE_REFERENCE: return createAbstractTypeReference();
			case TypesPackage.DEPRECATED_TYPE_REFERENCE: return createDeprecatedTypeReference();
			case TypesPackage.INSTANCE_TYPE_REFERENCE: return createInstanceTypeReference();
			case TypesPackage.NAMED_TYPE_REFERENCE: return createNamedTypeReference();
			case TypesPackage.CONSTRAINED_ARRAY_TYPE_REFERENCE: return createConstrainedArrayTypeReference();
			case TypesPackage.ABSTRACT_COLLECTION_TYPE_REFERENCE: return createAbstractCollectionTypeReference();
			case TypesPackage.SEQUENCE_TYPE_REFERENCE: return createSequenceTypeReference();
			case TypesPackage.ARRAY_TYPE_REFERENCE: return createArrayTypeReference();
			case TypesPackage.SET_TYPE_REFERENCE: return createSetTypeReference();
			case TypesPackage.BAG_TYPE_REFERENCE: return createBagTypeReference();
			case TypesPackage.DICTIONARY_TYPE_REFERENCE: return createDictionaryTypeReference();
			default:
				throw new IllegalArgumentException("The class '" + eClass.getName() + "' is not a valid classifier");
		}
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TypeDeclaration createTypeDeclaration() {
		TypeDeclarationImpl typeDeclaration = new TypeDeclarationImpl();
		return typeDeclaration;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TypeForwardDeclaration createTypeForwardDeclaration() {
		TypeForwardDeclarationImpl typeForwardDeclaration = new TypeForwardDeclarationImpl();
		return typeForwardDeclaration;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BuiltinTypeDeclaration createBuiltinTypeDeclaration() {
		BuiltinTypeDeclarationImpl builtinTypeDeclaration = new BuiltinTypeDeclarationImpl();
		return builtinTypeDeclaration;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TerminatorTypeReference createTerminatorTypeReference() {
		TerminatorTypeReferenceImpl terminatorTypeReference = new TerminatorTypeReferenceImpl();
		return terminatorTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public AbstractTypeDefinition createAbstractTypeDefinition() {
		AbstractTypeDefinitionImpl abstractTypeDefinition = new AbstractTypeDefinitionImpl();
		return abstractTypeDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConstrainedTypeDefinition createConstrainedTypeDefinition() {
		ConstrainedTypeDefinitionImpl constrainedTypeDefinition = new ConstrainedTypeDefinitionImpl();
		return constrainedTypeDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public AbstractTypeConstraint createAbstractTypeConstraint() {
		AbstractTypeConstraintImpl abstractTypeConstraint = new AbstractTypeConstraintImpl();
		return abstractTypeConstraint;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public RangeConstraint createRangeConstraint() {
		RangeConstraintImpl rangeConstraint = new RangeConstraintImpl();
		return rangeConstraint;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DeltaConstraint createDeltaConstraint() {
		DeltaConstraintImpl deltaConstraint = new DeltaConstraintImpl();
		return deltaConstraint;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DigitsConstraint createDigitsConstraint() {
		DigitsConstraintImpl digitsConstraint = new DigitsConstraintImpl();
		return digitsConstraint;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public StructureTypeDefinition createStructureTypeDefinition() {
		StructureTypeDefinitionImpl structureTypeDefinition = new StructureTypeDefinitionImpl();
		return structureTypeDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public StructureComponentDefinition createStructureComponentDefinition() {
		StructureComponentDefinitionImpl structureComponentDefinition = new StructureComponentDefinitionImpl();
		return structureComponentDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EnumerationTypeDefinition createEnumerationTypeDefinition() {
		EnumerationTypeDefinitionImpl enumerationTypeDefinition = new EnumerationTypeDefinitionImpl();
		return enumerationTypeDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Enumerator createEnumerator() {
		EnumeratorImpl enumerator = new EnumeratorImpl();
		return enumerator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public UnconstrainedArrayDefinition createUnconstrainedArrayDefinition() {
		UnconstrainedArrayDefinitionImpl unconstrainedArrayDefinition = new UnconstrainedArrayDefinitionImpl();
		return unconstrainedArrayDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public AbstractTypeReference createAbstractTypeReference() {
		AbstractTypeReferenceImpl abstractTypeReference = new AbstractTypeReferenceImpl();
		return abstractTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DeprecatedTypeReference createDeprecatedTypeReference() {
		DeprecatedTypeReferenceImpl deprecatedTypeReference = new DeprecatedTypeReferenceImpl();
		return deprecatedTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public InstanceTypeReference createInstanceTypeReference() {
		InstanceTypeReferenceImpl instanceTypeReference = new InstanceTypeReferenceImpl();
		return instanceTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NamedTypeReference createNamedTypeReference() {
		NamedTypeReferenceImpl namedTypeReference = new NamedTypeReferenceImpl();
		return namedTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConstrainedArrayTypeReference createConstrainedArrayTypeReference() {
		ConstrainedArrayTypeReferenceImpl constrainedArrayTypeReference = new ConstrainedArrayTypeReferenceImpl();
		return constrainedArrayTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public AbstractCollectionTypeReference createAbstractCollectionTypeReference() {
		AbstractCollectionTypeReferenceImpl abstractCollectionTypeReference = new AbstractCollectionTypeReferenceImpl();
		return abstractCollectionTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SequenceTypeReference createSequenceTypeReference() {
		SequenceTypeReferenceImpl sequenceTypeReference = new SequenceTypeReferenceImpl();
		return sequenceTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArrayTypeReference createArrayTypeReference() {
		ArrayTypeReferenceImpl arrayTypeReference = new ArrayTypeReferenceImpl();
		return arrayTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SetTypeReference createSetTypeReference() {
		SetTypeReferenceImpl setTypeReference = new SetTypeReferenceImpl();
		return setTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BagTypeReference createBagTypeReference() {
		BagTypeReferenceImpl bagTypeReference = new BagTypeReferenceImpl();
		return bagTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DictionaryTypeReference createDictionaryTypeReference() {
		DictionaryTypeReferenceImpl dictionaryTypeReference = new DictionaryTypeReferenceImpl();
		return dictionaryTypeReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TypesPackage getTypesPackage() {
		return (TypesPackage)getEPackage();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @deprecated
	 * @generated
	 */
	@Deprecated
	public static TypesPackage getPackage() {
		return TypesPackage.eINSTANCE;
	}

} //TypesFactoryImpl
