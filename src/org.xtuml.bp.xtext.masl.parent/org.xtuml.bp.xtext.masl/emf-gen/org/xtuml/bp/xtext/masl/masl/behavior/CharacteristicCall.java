/**
 * generated by Xtext 2.9.2
 */
package org.xtuml.bp.xtext.masl.masl.behavior;

import org.eclipse.emf.common.util.EList;

import org.xtuml.bp.xtext.masl.masl.structure.Characteristic;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Characteristic Call</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.xtuml.bp.xtext.masl.masl.behavior.CharacteristicCall#getReceiver <em>Receiver</em>}</li>
 *   <li>{@link org.xtuml.bp.xtext.masl.masl.behavior.CharacteristicCall#getCharacteristic <em>Characteristic</em>}</li>
 *   <li>{@link org.xtuml.bp.xtext.masl.masl.behavior.CharacteristicCall#getArguments <em>Arguments</em>}</li>
 * </ul>
 *
 * @see org.xtuml.bp.xtext.masl.masl.behavior.BehaviorPackage#getCharacteristicCall()
 * @model
 * @generated
 */
public interface CharacteristicCall extends Expression {
	/**
	 * Returns the value of the '<em><b>Receiver</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Receiver</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Receiver</em>' containment reference.
	 * @see #setReceiver(Expression)
	 * @see org.xtuml.bp.xtext.masl.masl.behavior.BehaviorPackage#getCharacteristicCall_Receiver()
	 * @model containment="true"
	 * @generated
	 */
	Expression getReceiver();

	/**
	 * Sets the value of the '{@link org.xtuml.bp.xtext.masl.masl.behavior.CharacteristicCall#getReceiver <em>Receiver</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Receiver</em>' containment reference.
	 * @see #getReceiver()
	 * @generated
	 */
	void setReceiver(Expression value);

	/**
	 * Returns the value of the '<em><b>Characteristic</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Characteristic</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Characteristic</em>' reference.
	 * @see #setCharacteristic(Characteristic)
	 * @see org.xtuml.bp.xtext.masl.masl.behavior.BehaviorPackage#getCharacteristicCall_Characteristic()
	 * @model
	 * @generated
	 */
	Characteristic getCharacteristic();

	/**
	 * Sets the value of the '{@link org.xtuml.bp.xtext.masl.masl.behavior.CharacteristicCall#getCharacteristic <em>Characteristic</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Characteristic</em>' reference.
	 * @see #getCharacteristic()
	 * @generated
	 */
	void setCharacteristic(Characteristic value);

	/**
	 * Returns the value of the '<em><b>Arguments</b></em>' containment reference list.
	 * The list contents are of type {@link org.xtuml.bp.xtext.masl.masl.behavior.Expression}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Arguments</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Arguments</em>' containment reference list.
	 * @see org.xtuml.bp.xtext.masl.masl.behavior.BehaviorPackage#getCharacteristicCall_Arguments()
	 * @model containment="true"
	 * @generated
	 */
	EList<Expression> getArguments();

} // CharacteristicCall
