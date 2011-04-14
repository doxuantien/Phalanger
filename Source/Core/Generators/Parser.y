/*

Copyright (c) 2006 Tomas Matousek.
Copyright (c) 2003-2005 Vaclav Novak (previous MC++ version for Flex/Bison)

Parser was generated using The Gardens Point Parser Generator (GPPG) using PHP language grammar based on Flex and Bison files
distributed with PHP5 and PHP6 interpreter.

*/

using PHP.Core;
using PHP.Core.AST;
using PHP.Core.AST.Linq;
using PHP.Core.Reflection;
using PHP.Core.Parsers.GPPG;
using Pair = System.Tuple<object,object>;

%%

%namespace PHP.Core.Parsers
%valuetype SemanticValueType
%positiontype Position
%tokentype Toks
%visibility public

%union
{
	// Integer and Offset are both used when generating code for string 
	// with 'inline' variables. Other fields are not combined.
	
	[System.Runtime.InteropServices.FieldOffset(0)]		
	public int Integer;
	[System.Runtime.InteropServices.FieldOffset(4)]
	public int Offset;

	[System.Runtime.InteropServices.FieldOffset(0)]
	public double Double;
	[System.Runtime.InteropServices.FieldOffset(0)]
	public long Long;

	[System.Runtime.InteropServices.FieldOffset(8)]
	public object Object; 
}

/*
  Ambiguities:
  
	%expect 5
	
  2 due to the dangling elseif/else.  Solved by shift.
  1 due to LINQ. Solved by shift (from ... select ... from ... select as in ...).
  1 due to arrays within encapsulated strings. Solved by shift. 
  1 due to objects within encapsulated strings.  Solved by shift.
  
	  ambiguity:
	  
	  if (1)
	    if (2) echo "2";
	    else[if (3)] echo "3";
			    
		reduction on else/elseif:
		
		if (1)
	    { if (2) echo "2"; }
	    else[if (3)] echo "3";
		
		shift on else/elseif (preferred):   
		
		if (1)
	    { if (2) echo "2";
	      else[if (3)] echo "3"; }
		
		
		ambiguity:	    
			    
		from $a as $b 
		select 
		  from $c as $d 
		  select $e 
		  as $f in from $g as $h select $i;

		reduction on as:
		
		from $a as $b 
		select 
		  (from $c as $d 
		  select $e) 
		as $f in from $g as $h select $i;

		shift on as (preferred):
		
		from $a as $b 
		select 
		  (from $c as $d 
		  select $e 
		  as $f in from $g as $h select $i);


*/


/* operators, starting from the least precedence */


/* PHP operators start from 258 */

%left T_INCLUDE T_INCLUDE_ONCE T_EVAL T_REQUIRE T_REQUIRE_ONCE
%left ','

%left T_LINQ_SELECT T_LINQ_BY 

%left T_LOGICAL_OR
%left T_LOGICAL_XOR
%left T_LOGICAL_AND
%right T_PRINT
%left '=' T_PLUS_EQUAL T_MINUS_EQUAL T_MUL_EQUAL T_DIV_EQUAL T_CONCAT_EQUAL T_MOD_EQUAL T_AND_EQUAL T_OR_EQUAL T_XOR_EQUAL T_SL_EQUAL T_SR_EQUAL
%left '?' ':'
%left T_BOOLEAN_OR
%left T_BOOLEAN_AND
%left '|'
%left '^'
%left '&'
%nonassoc T_IS_EQUAL T_IS_NOT_EQUAL T_IS_IDENTICAL T_IS_NOT_IDENTICAL
%nonassoc '<' T_IS_SMALLER_OR_EQUAL '>' T_IS_GREATER_OR_EQUAL
%left T_SL T_SR
%left '+' '-' '.'
%left '*' '/' '%'
%right '!' '~' T_INC T_DEC '@' TypeCast
%right '['
%nonassoc T_NEW T_INSTANCEOF T_TYPEOF T_CLONE

/* terminals declaration */

%token<Integer> T_LNUMBER                 // int
%token<Long> T_L64NUMBER                  // long 
%token<Double> T_DNUMBER                  // double
%token T_STRING
%token T_STRING_VARNAME
%token<Object> T_VARIABLE
%token T_NUM_STRING
%token<Object> T_INLINE_HTML              // string
%token<Integer> T_CHARACTER               // char
%token T_BAD_CHARACTER
%token T_ENCAPSED_AND_WHITESPACE
%token<Object> T_CONSTANT_ENCAPSED_STRING // string
%token T_EXIT
%token T_IF
%token T_ELSEIF
%token T_ELSE
%token T_ENDIF
%token T_ECHO
%token T_DO
%token T_WHILE
%token T_ENDWHILE
%token T_FOR
%token T_ENDFOR
%token T_FOREACH
%token T_ENDFOREACH
%token T_AS
%token T_SWITCH
%token T_ENDSWITCH
%token T_CASE
%token T_DEFAULT
%token T_BREAK
%token T_CONTINUE
%token<Object> T_FUNCTION                 // string (doc comment)
%token<Object> T_CONST                    // string (doc comment)
%token T_RETURN
%token T_GLOBAL
%token T_STATIC 
%token<Object> T_VAR                      // string (doc comment)
%token T_UNSET
%token T_ISSET
%token T_EMPTY
%token<Object> T_CLASS                    // string (doc comment)
%token T_EXTENDS
%token T_OBJECT_OPERATOR
%token T_DOUBLE_ARROW
%token T_LIST
%token T_ARRAY
%token T_CLASS_C
%token T_METHOD_C
%token T_FUNC_C
%token T_LINE
%token T_FILE
%token T_DIR
%token T_COMMENT
%token T_DOC_COMMENT
%token T_PRAGMA_LINE
%token T_PRAGMA_FILE
%token T_PRAGMA_DEFAULT_LINE
%token T_PRAGMA_DEFAULT_FILE
%token T_OPEN_TAG
%token T_OPEN_TAG_WITH_ECHO
%token T_CLOSE_TAG
%token T_WHITESPACE
%token T_START_HEREDOC
%token T_END_HEREDOC
%token T_DOLLAR_OPEN_CURLY_BRACES
%token T_CURLY_OPEN
%token T_DOUBLE_COLON
%token T_PLUS_EQUAL  
%token T_MINUS_EQUA  
%token T_MUL_EQUAL   
%token T_DIV_EQUAL   
%token T_CONCAT_EQUAL
%token T_MOD_EQUAL   
%token T_AND_EQUAL   
%token T_OR_EQUAL    
%token T_XOR_EQUAL   
%token T_SL_EQUAL    
%token T_SR_EQUAL 

/* PHP5 */

%token T_GOTO
%token T_TRY
%token T_CATCH
%token T_THROW
%token<Object> T_INTERFACE                // string (doc comment)
%token T_IMPLEMENTS
%token T_ABSTRACT 
%token T_FINAL 
%token T_PRIVATE 
%token T_PROTECTED 
%token T_PUBLIC 
%token T_CLONE
%token T_INSTANCEOF

/* PHP6 */

%token T_BINARY_DOUBLE
%token T_BINARY_HEREDOC
%token T_IMPORT
%token T_NAMESPACE
%token T_NAMESPACE_C
%token<Object> T_NAMESPACE_NAME          // List<string>

/* PHP/CLR */

%token T_PARENT  
%token T_SELF  
%token T_TRUE  
%token T_FALSE  
%token T_NULL

%token T_GET  
%token T_SET  
%token T_CALL  
%token T_CALLSTATIC
%token T_TOSTRING
%token T_CONSTRUCT
%token T_DESTRUCT
%token T_WAKEUP  
%token T_SLEEP  
%token T_AUTOLOAD
%token T_ASSERT

%token T_PARTIAL
%token T_LGENERIC
%token T_RGENERIC

%token T_LINQ_SELECT
%token T_LINQ_BY
%token T_LINQ_WHERE
%token T_LINQ_DESCENDING
%token T_LINQ_ASCENDING
%token T_LINQ_ORDERBY
%token T_LINQ_GROUP
%token T_LINQ_FROM
%token T_LINQ_IN

%token T_BOOL_TYPE
%token T_INT_TYPE
%token T_INT64_TYPE
%token T_DOUBLE_TYPE 
%token T_STRING_TYPE 
%token T_RESOURCE_TYPE
%token T_OBJECT_TYPE
%token T_TYPEOF

%token T_BOOL_CAST   
%token T_INT8_CAST   
%token T_INT16_CAST  
%token T_INT32_CAST  
%token T_INT64_CAST  
%token T_UINT8_CAST  
%token T_UINT16_CAST 
%token T_UINT32_CAST 
%token T_UINT64_CAST 
%token T_DOUBLE_CAST 
%token T_FLOAT_CAST  
%token T_DECIMAL_CAST
%token T_STRING_CAST 
%token T_BINARY_CAST
%token T_UNICODE_CAST
%token T_ARRAY_CAST  
%token T_OBJECT_CAST 
%token T_UNSET_CAST  
  
/* Nonterminals */

%type<Integer> simple_indirect_reference              // int - number of indirections
%type<Integer> reference_opt                          // 0 (false) or 1 (true)
%type<Object> identifier                              // String

%type<Object> start 
%type<Object> non_empty_top_statement                 // Statement
%type<Object> top_statement                           // Statement
%type<Object> top_statement_list                      // List<Statement> 
%type<Object> import_list                             // null
%type<Object> import_statement                        // null
%type<Object> statement                               // Statement
%type<Object> empty_statement                         // EmptyStmt
%type<Object> non_empty_statement                     // Statement
%type<Object> expression_statement                    // ExpressionStmt
%type<Object> namespace_statement_list_opt                // List<Statement>
%type<Object> namespace_statement                     // Statement
%type<Object> function_declaration_statement          // FunctionDecl
%type<Object> class_declaration_statement             // TypeDecl
%type<Object> namespace_declaration_statement         // NamespaceDecl
%type<Object> global_constant_declarator              // GlobalConstantDecl
%type<Object> global_constant_declarator_list         // List<GlobalConstantDecl>
%type<Object> global_constant_declaration_statement   // GlobalConstDeclList
%type<Object> inner_statement_list_opt                    // List<Statement>
%type<Object> inner_statement                         // Statement
%type<Object> expr                                    // Expression
%type<Object> concat_exprs							  // List<Expression>
%type<Object> assignment_expression                   // AssignEx
%type<Integer> cast_operation                         // Operation
%type<Object> expr_without_chain                      // Expression
%type<Object> expression_list                         // List<Expression>/*!*/
%type<Object> expression_list_opt                     // List<Expression> 
%type<Object> foreach_variable                        // ForeachVar
%type<Object> attributes_opt                          // List<CustomAttribute>
%type<Object> attribute                               // CustomAttribute
%type<Object> attribute_list                          // List<CustomAttribute>
%type<Object> attribute_named_arg_list                // List<NamedActualParam>
%type<Object> attribute_named_arg                     // NamedActualParam
%type<Object> attribute_arg                           // ActualParam
%type<Object> attribute_arg_list                      // List<ActualParam>

%type<Object> constant                                // Expression 
%type<Object> literal_constant                        // Literal 
%type<Object> pseudo_constant                         // PseudoConstUse 
%type<Object> global_constant                         // GlobalConstUse 
%type<Object> class_constant                          // ClassConstUse

%type<Object> constant_inititalizer                   // Expression
%type<Object> scalar_expr                             // Expression
%type<Object> for_statement                           // Statement
%type<Object> foreach_statement                       // Statement
%type<Object> while_statement                         // Statement
%type<Object> elseif_list_opt                             // List<ConditionalStmt>
%type<Object> elseif_colon_list_opt                       // List<ConditionalStmt>
%type<Object> else_opt                                // Statement
%type<Object> else_colon_opt                          // Statement

%type<Object> formal_parameter                        // FormalParam!
%type<Object> formal_parameter_list                   // List<FormalParam>!
%type<Object> formal_parameter_list_opt               // List<FormalParam>!
%type<Object> type_parameter_list_opt                 // List<FormalTypeParam>!
%type<Object> type_parameter_list                     // List<FormalTypeParam>!
%type<Object> type_parameter_with_defaults_list       // List<FormalTypeParam>!
%type<Object> type_parameter_decl                     // FormalTypeParam!
%type<Object> type_parameter_with_default_decl        // FormalTypeParam!
%type<Object> actual_argument                         // ActualParam!
%type<Object> actual_argument_list                    // List<ActualParam>!
%type<Object> actual_argument_list_opt                // List<ActualParam>!
%type<Object> actual_arguments_opt                    // Pair of List<TypeRef> and List<ActualParam>
%type<Object> base_ctor_call_opt                      // List<ActualParam>


%type<Object> array_item                              // Item
%type<Object> array_item_list                         // List<Item>
%type<Object> array_item_list_opt                     // List<Item>
%type<Object> constant_array_item                     // Item
%type<Object> constant_array_item_list_opt            // List<Item>
%type<Object> constant_array_item_list                // List<Item>

%type<Object> exit_expr_opt                               // ExitEx
%type<Object> key_opt   
%type<Object> composite_string_opt                        // List<Expression> 
%type<Object> string_embedded_key                     // Expression
%type<Object> unsupported_declare_list                // null
%type<Object> function_call                           // FunctionCall
%type<Object> type_ref                                // TypeRef!
%type<Object> type_ref_list                           // List<TypeRef>
%type<Object> qualified_static_type_ref               // GenericQualifiedName
%type<Object> interface_list                          // List<GenericQualifiedName>
%type<Object> interface_extends_opt                  // List<GenericQualifiedName>
%type<Object> variable_name                           

%type<Object> generic_dynamic_args_opt                // List<TypeRef>!
%type<Object> primitive_type                          // PrimitiveType

%type<Object> type_hint_opt                           // object (null, GenericQualifiedName, PrimitiveType)
%type<Object> chain_base_with_function_calls       
%type<Object> keyed_simple_field_name 
%type<Object> chain                                   // VarLikeConstructUse 
%type<Object> chain_base 
%type<Object> keyed_field_name                        // CompoundVarUse
%type<Object> indirect_type_ref                       // VariableUse
%type<Object> writable_chain                          // VarLikeConstructUse
%type<Object> assignment_list_element_opt                 // Expression
%type<Object> writable_chain_list
%type<Object> assignment_list                         // List<Expression>
%type<Object> global_var                              // SimpleVarUse
%type<Object> static_variable                         // StaticVarDecl
%type<Object> static_variable_list                    // List<StaticVarDecl>!
%type<Object> property_declarator                     // FieldDecl!
%type<Object> property_declarator_list                // List<FieldDecl>!
%type<Object> keyed_compound_variable      
%type<Object> compound_variable 
%type<Object> string_embedded_variable 
%type<Object> global_var_list                     		// List<SimpleVarUse>!
%type<Object> keyed_variable
%type<Object> member_access_chain_opt 
%type<Object> member_access 
%type<Object> switch_case_list 
%type<Object> case_list_opt
%type<Object> method_body 
%type<Object> foreach_optional_arg 
%type<Object> keyed_field_names_opt
%type<Object> class_constant_declarator               // ClassConstantDecl!
%type<Object> class_constant_declarator_list          // List<ClassConstantDecl>!
%type<Object> class_statement_list_opt
%type<Object> class_statement
%type<Object> class_method_identifier				  // String
%type<Object> implements_opt 
%type<Object> ctor_arguments_opt
%type<Object> dynamic_class_name_variable_property 
%type<Object> additional_catches_opt 
%type<Object> additional_catches

%type<Object> linq_query_expression 
%type<Object> linq_from_clause 
%type<Object> linq_generator_list 
%type<Object> linq_generator
%type<Object> linq_query_body 
%type<Object> linq_from_where_clause_list_opt 
%type<Object> linq_where_clause 
%type<Object> linq_orderby_clause_opt 
%type<Object> linq_ordering_list 
%type<Object> linq_ordering_clause 
%type<Object> linq_select_groupby_clause 
%type<Object> linq_into_clause_opt

%type<Integer> modifier_opt                  // PhpMemberAttributes
%type<Integer> visibility_opt                // PhpMemberAttributes
%type<Integer> partial_opt                   // int (0, 1)

%type<Integer> property_modifiers            // PhpMemberAttributes
%type<Integer> member_modifiers_opt          // PhpMemberAttributes
%type<Integer> member_modifiers              // PhpMemberAttributes
%type<Integer> member_modifier               // PhpMemberAttributes

%type<Integer> attribute_target_opt          // CustomAttribute.Targets

%type<Object> extends_opt                   // GenericQualifiedName?
%type<Object> namespace_name                 // QualifiedName (with a base name)

%% /* Productions */

start:
	  colons_opt import_list 
	  { 
			astRoot = new GlobalCode(emptyStatementList, sourceUnit);
		}
	| colons_opt import_list top_statement_list 
	  { 
			astRoot = new GlobalCode((List<Statement>)$3, sourceUnit);
		}
	| colons_opt non_empty_top_statement 
	  { 
	    List<Statement> top_statements = new List<Statement>();
	    top_statements.Insert(0, (Statement)$2);
			astRoot = new GlobalCode(top_statements, sourceUnit);
		}
	| colons_opt non_empty_top_statement top_statement_list 
	  { 
	    List<Statement> top_statements = (List<Statement>)$3;
	    top_statements.Insert(0, (Statement)$2);
			astRoot = new GlobalCode(top_statements, sourceUnit);
		}
	| colons_opt
	  { 
			astRoot = new GlobalCode(emptyStatementList, sourceUnit);
		}
;

colons_opt:
    colons_opt ';' { /* nop */ }
  | /* empty */    { /* nop */ }
;

comma_opt:
	  ','            { /* nop */ }
	|	/* empty */    { /* nop */ }
;

/* Added to distinguish identifiers from encapsulated strings both represented by T_STRING */
identifier:
		T_STRING { $$ = $1.Object; }
;

import_list:
    import_list import_statement  { /* nop */ } 
  | import_statement              { /* nop */ }
;

import_statement: /* PHP-NS, PHP/CLR */
		T_IMPORT T_CLASS T_NAMESPACE_NAME ';'                    { AddImport(@$, DeclarationKind.Type, (List<string>)$3, null); }            
	|	T_IMPORT T_CLASS T_NAMESPACE_NAME T_AS identifier ';'    { AddImport(@$, DeclarationKind.Type, (List<string>)$3, (string)$5); }      
	|	T_IMPORT T_INTERFACE T_NAMESPACE_NAME ';'                { AddImport(@$, DeclarationKind.Type, (List<string>)$3, null); }             /* PHP/CLR */
	|	T_IMPORT T_INTERFACE T_NAMESPACE_NAME T_AS identifier ';'{ AddImport(@$, DeclarationKind.Type, (List<string>)$3, (string)$5); }       /* PHP/CLR */
	|	T_IMPORT T_FUNCTION T_NAMESPACE_NAME ';'                 { AddImport(@$, DeclarationKind.Function, (List<string>)$3, null); }         
	|	T_IMPORT T_FUNCTION T_NAMESPACE_NAME T_AS identifier ';' { AddImport(@$, DeclarationKind.Function, (List<string>)$3, (string)$5); }   
	|	T_IMPORT T_CONST T_NAMESPACE_NAME ';'                    { AddImport(@$, DeclarationKind.Constant, (List<string>)$3, null); }         /* PHP/CLR */
	|	T_IMPORT T_CONST T_NAMESPACE_NAME T_AS identifier ';'    { AddImport(@$, DeclarationKind.Constant, (List<string>)$3, (string)$5); }   /* PHP/CLR */
	|	T_IMPORT T_NAMESPACE T_NAMESPACE_NAME ';'                { AddImport((List<string>)$3); }                                            
	|	T_IMPORT T_NAMESPACE identifier ';'                      { AddImport((string)$3); }
	
	// errors:
	|	T_IMPORT ERROR { errors.Add(Errors.MissingImportedEntity, SourceUnit, @2); yyerrok(); } T_NAMESPACE_NAME  ';' { AddImport((List<string>)$4); }
	|	T_IMPORT ERROR { errors.Add(Errors.MissingImportedEntity, SourceUnit, @2); yyerrok(); } identifier        ';' { AddImport((string)$4); }
;

top_statement_list:
		top_statement_list top_statement { $$ = $1; if ($2 != null) ListAdd<Statement>($$, $2); } 
	|	top_statement                    { $$ = NewList<Statement>($1); }
;

top_statement:
		empty_statement                 { $$ = $1; }
	|	non_empty_top_statement         { $$ = $1; } 
;

non_empty_top_statement:
		non_empty_statement             { $$ = CheckGlobalStatement((Statement)$1); }
	|	function_declaration_statement	{ $$ = $1; }
	|	class_declaration_statement		  { $$ = $1; }
	|	namespace_declaration_statement { $$ = $1; } /* PHP6 */
	| global_constant_declaration_statement { $$ = $1; } /* PHP/CLR */
;

namespace_declaration_statement:   /* PHP6 */ 	 
		T_NAMESPACE 
		{ 
			currentNamespace = new NamespaceDecl(@$);
		} 
		'{' namespace_statement_list_opt '}' 
		{
			currentNamespace.Statements = (List<Statement>)$4;
			$$ = currentNamespace;
			currentNamespace = null;
		}
		
	|	T_NAMESPACE T_NAMESPACE_NAME 
		{ 
			currentNamespace = new NamespaceDecl(@$, (List<string>)$2);
		} 
		'{' namespace_statement_list_opt '}' 
		{
			currentNamespace.Statements = (List<Statement>)$5;
			$$ = currentNamespace;
			currentNamespace = null;
		}
		
	|	T_NAMESPACE identifier 
		{ 
			currentNamespace = new NamespaceDecl(@$, (string)$2);
		} 
		'{' namespace_statement_list_opt '}' 
		{
			currentNamespace.Statements = (List<Statement>)$5;
			$$ = currentNamespace;
			currentNamespace = null;
		}		
;

namespace_statement_list_opt: 	 /* PHP6 */
		namespace_statement_list_opt namespace_statement  { $$ = $1; ListAdd<Statement>($1, $2); }	 
	|	/* empty */                                       { $$ = new List<Statement>(); }
;

namespace_statement:         /* PHP6 */
		function_declaration_statement       { $$ = $1; }
	|	class_declaration_statement          { $$ = $1; }
	|	global_constant_declarator_list ';'  { $$ = $1; }
;

function_declaration_statement:
		attributes_opt visibility_opt T_FUNCTION attributes_opt reference_opt identifier 
		type_parameter_list_opt '(' formal_parameter_list_opt ')' 
		{ 
		  EnterConditionalCode(); 
		}
		'{' inner_statement_list_opt '}'
		{ 
			CheckTypeParameterNames((List<FormalTypeParam>)$7, (string)$6);
			
			$$ = new FunctionDecl(sourceUnit, @6, @$, GetHeadingEnd(@10), GetBodyStart(@12), 
				IsCurrentCodeOneLevelConditional, GetScope(), 
				(PhpMemberAttributes)$2 | PhpMemberAttributes.Static,
				(string)$6, currentNamespace, $5 != 0, 
			  (List<FormalParam>)$9, (List<FormalTypeParam>)$7, (List<Statement>)$13, (List<CustomAttribute>)$1, 
			  (List<CustomAttribute>)$4);
			  
			CommentSet cs = new CommentSet(new Comment[] {new Comment(CommentType.Documentation, CommentPosition.Before, (string)$3)} );
			  
			($$ as LangElement).Annotations.Set<CommentSet>(cs);
			
			reductionsSink.FunctionDeclarationReduced(this,	(FunctionDecl)$$); 
			  
			LeaveConditionalCode();	
		} 
;

class_declaration_statement:
		attributes_opt visibility_opt modifier_opt partial_opt class
		identifier type_parameter_list_opt extends_opt implements_opt 
		'{' class_statement_list_opt '}' 
		{ 
		  Name class_name = new Name((string)$6);
		  
		  CheckReservedNamesAbsence((GenericQualifiedName?)$8, @8);
		  CheckReservedNamesAbsence((List<GenericQualifiedName>)$9, @9);
		  CheckReservedNameAbsence(class_name, @6);
			CheckTypeParameterNames((List<FormalTypeParam>)$7, (string)$6);
		  
		  $$ = new TypeDecl(sourceUnit, CombinePositions(@5, @6), @$, GetHeadingEnd(GetLeftValidPosition(9)), GetBodyStart(@10), 
				IsCurrentCodeConditional, GetScope(), 
				(PhpMemberAttributes)($2 | $3), $4 != 0, class_name, currentNamespace, 
				(List<FormalTypeParam>)$7, (GenericQualifiedName?)$8, (List<GenericQualifiedName>)$9, 
		    (List<TypeMemberDecl>)$11, (List<CustomAttribute>)$1);
		    
		  CommentSet cs = new CommentSet(new Comment[] {new Comment(CommentType.Documentation, CommentPosition.Before, PopDocComment())} );
			  
		  ($$ as LangElement).Annotations.Set<CommentSet>(cs);
				
		  reductionsSink.TypeDeclarationReduced(this, (TypeDecl)$$);
		}
			
	|	attributes_opt visibility_opt modifier_opt partial_opt interface 
	  identifier type_parameter_list_opt interface_extends_opt 
		'{' class_statement_list_opt '}' 
	  { 
		  Name class_name = new Name((string)$6);
		  
		  CheckReservedNamesAbsence((List<GenericQualifiedName>)$8, @8);
		  CheckReservedNameAbsence(class_name, @6);
		  CheckTypeParameterNames((List<FormalTypeParam>)$7, (string)$6);
		  
			if ((PhpMemberAttributes)$3 != PhpMemberAttributes.None)
				errors.Add(Errors.InvalidInterfaceModifier, SourceUnit, @3);
				
		  $$ = new TypeDecl(sourceUnit, CombinePositions(@5, @6), @$, GetHeadingEnd(GetLeftValidPosition(8)), GetBodyStart(@9),
				IsCurrentCodeConditional, GetScope(), 
				(PhpMemberAttributes)$2 | PhpMemberAttributes.Abstract | PhpMemberAttributes.Interface, 
				$4 != 0, class_name, currentNamespace, (List<FormalTypeParam>)$7, null, (List<GenericQualifiedName>)$8, (List<TypeMemberDecl>)$10, 
				(List<CustomAttribute>)$1); 
				
		  CommentSet cs = new CommentSet(new Comment[] {new Comment(CommentType.Documentation, CommentPosition.Before, PopDocComment())} );
			  
		  ($$ as LangElement).Annotations.Set<CommentSet>(cs);
			
			reductionsSink.TypeDeclarationReduced(this, (TypeDecl)$$);
	  }
;

class:
	T_CLASS { PushDocComment($1); }
;

interface:
	T_INTERFACE { PushDocComment($1); }
;

modifier_opt:
		/* empty */
	| T_ABSTRACT  { $$ = (int)PhpMemberAttributes.Abstract; }
	| T_FINAL     { $$ = (int)PhpMemberAttributes.Final; }
;

visibility_opt:
	  /* empty */ { $$ = (int)PhpMemberAttributes.Public; }
	| T_PRIVATE   { $$ = (int)CheckPrivateType(@1); }
;

partial_opt:
	  /* empty */ { $$ = 0; }
	| T_PARTIAL   { $$ = CheckPartialType(@1); }
;

extends_opt:
		/* empty */														{ $$ = null; }
	|	T_EXTENDS qualified_static_type_ref	{ $$ = (GenericQualifiedName)$2; }
;

interface_extends_opt:
		/* empty */								{ $$ = emptyGenericQualifiedNameList; }
	|	T_EXTENDS interface_list	{ $$ = $2; }
;

implements_opt:
		/* empty */										{ $$ = emptyGenericQualifiedNameList; }
	|	T_IMPLEMENTS interface_list		{ $$ = $2; }
;

interface_list:
		qualified_static_type_ref						
		{ 
			$$ = NewList<GenericQualifiedName>($1);
		}		
		
	|	interface_list ',' qualified_static_type_ref	
		{ 
			$$ = $1; 
			ListAdd<GenericQualifiedName>($$, $3); 
		}
;


type_parameter_list_opt:
    T_LGENERIC type_parameter_list T_RGENERIC                                       { $$ = $2; }
  | T_LGENERIC type_parameter_with_defaults_list T_RGENERIC                         { $$ = $2; }
  | T_LGENERIC type_parameter_list ',' type_parameter_with_defaults_list T_RGENERIC { $$ = $2; ((List<FormalTypeParam>)$2).AddRange((List<FormalTypeParam>)$4); }
  | /* empty */                                                                     { $$ = emptyFormalTypeParamList; }
;

type_parameter_list:
		type_parameter_list ',' type_parameter_decl { ListAdd<FormalTypeParam>($1, $3); $$ = $1; }
	| type_parameter_decl                         { $$ = NewList<FormalTypeParam>($1); }
;

type_parameter_with_defaults_list:
		type_parameter_with_defaults_list ',' type_parameter_with_default_decl { ListAdd<FormalTypeParam>($1, $3); $$ = $1; }
	| type_parameter_with_default_decl                                       { $$ = NewList<FormalTypeParam>($1); }
;

type_parameter_decl:
  attributes_opt identifier
  { 
		Name name = new Name((string)$2);
		
		CheckReservedNameAbsence(name, @2);
		$$ = new FormalTypeParam(@2, name, null, (List<CustomAttribute>)$1); 
	}
;

type_parameter_with_default_decl:
	  attributes_opt identifier '=' qualified_static_type_ref 
	  { 
			Name name = new Name((string)$2);
			
			CheckReservedNameAbsence(name, @2);
			$$ = new FormalTypeParam(CombinePositions(@2, @4), name, $4, (List<CustomAttribute>)$1); 
		}
	|	attributes_opt identifier '=' primitive_type 
	  { 
			Name name = new Name((string)$2);
			
			CheckReservedNameAbsence(name, @2);
			$$ = new FormalTypeParam(CombinePositions(@2, @4), name, $4, (List<CustomAttribute>)$1); 
		}
;

primitive_type:
    T_BOOL_TYPE     { $$ = PrimitiveType.Boolean; }
  | T_INT_TYPE      { $$ = PrimitiveType.Integer; }
  | T_INT64_TYPE    { $$ = PrimitiveType.LongInteger; }
  | T_DOUBLE_TYPE   { $$ = PrimitiveType.Double; }
  | T_STRING_TYPE   { $$ = PrimitiveType.String; }
  | T_RESOURCE_TYPE { $$ = PrimitiveType.Resource; }
  | T_OBJECT_TYPE   { $$ = PrimitiveType.Object; }
  | T_ARRAY         { $$ = PrimitiveType.Array; }
;


generic_dynamic_args_opt:
    T_LGENERIC type_ref_list T_RGENERIC { $$ = $2; }
  | /* empty */                         { $$ = TypeRef.EmptyList; }
;
  

attributes_opt:
    attributes_opt '[' attribute_list ']'
    {
      $$ = AddCustomAttributes((List<CustomAttribute>)$1, (List<CustomAttribute>)$3, CustomAttribute.TargetSelectors.Default);
    }
  | attributes_opt '[' identifier ':' attribute_list ']' 
    { 
      $$ = AddCustomAttributes((List<CustomAttribute>)$1, (List<CustomAttribute>)$5, 
        IdentifierToTargetSelector(@3, (string)$3));
    } 
  | /* empty */ 
    { 
      $$ = null; 
    }
;  

attribute_list:	
		attribute_list ',' attribute 
		{ 
			ListAdd<CustomAttribute>($1, $3);
			$$ = $1; 
		}
	|	attribute	
		{ 
			$$ = NewList<CustomAttribute>($1);
		}
;

attribute:
		namespace_name 
		{ 
			$$ = new CustomAttribute(@$, (QualifiedName)$1, emptyActualParamListIndex, emptyNamedActualParamListIndex);
		}
	| namespace_name '(' attribute_arg_list ')' 
		{ 
			$$ = new CustomAttribute(@$, (QualifiedName)$1, (List<ActualParam>)$3, emptyNamedActualParamListIndex);
		}
	| namespace_name '(' attribute_named_arg_list ')' 
		{ 
			$$ = new CustomAttribute(@$, (QualifiedName)$1, emptyActualParamListIndex, (List<NamedActualParam>)$3);
		}
	| namespace_name '(' attribute_arg_list ',' attribute_named_arg_list ')' 
		{ 
			$$ = new CustomAttribute(@$, (QualifiedName)$1, (List<ActualParam>)$3, (List<NamedActualParam>)$5);
		}
;

attribute_arg_list:
		attribute_arg_list ',' attribute_arg 
		{ 
			ListAdd<ActualParam>($1, $3);
			$$ = $1; 
		}
	| attribute_arg
		{ 
			$$ = NewList<ActualParam>($1);
		}
;

attribute_named_arg_list:
		attribute_named_arg_list ',' attribute_named_arg 
		{ 
			ListAdd<NamedActualParam>($1, $3);
			$$ = $1; 
		}
	| attribute_named_arg
		{ 
			$$ = NewList<NamedActualParam>($1);
		}
;

attribute_arg:
	expr { $$ = new ActualParam(@$, (Expression)$1, false); }
;

attribute_named_arg:
	T_VARIABLE T_DOUBLE_ARROW expr { $$ = new NamedActualParam(@$, (string)$1, (Expression)$3); }
;




inner_statement_list_opt:
		inner_statement_list_opt inner_statement  { $$ = $1; if ($2 != null) ListAdd<Statement>($$, $2); }
	|	/* empty */                               { $$ = new List<Statement>(); }
;

inner_statement:
		statement												{ $$ = $1; }
	|	function_declaration_statement	{ $$ = $1; }
	|	class_declaration_statement			{ $$ = $1; }
;

empty_statement:
  ';' { $$ = new EmptyStmt(@$); }
;

expression_statement:
  expr ';' { $$ = new ExpressionStmt(@$, (Expression)$1); }
;

statement:
    non_empty_statement
  | empty_statement
;

non_empty_statement:
		identifier ':'     
		{ 
		  $$ = new LabelStmt(@$, (string)$1); /* PHP6 */ 
		}
		
	|	'{' inner_statement_list_opt '}' 
		{ 
		  $$ = new BlockStmt(@$, (List<Statement>)$2); 
		}
		
	|	T_IF '(' expr ')'  
		{ 
			EnterConditionalCode(); 
		} 
		statement elseif_list_opt else_opt 
		{ 
			List<ConditionalStmt> conditions = (List<ConditionalStmt>)$7;
			conditions[0] = new ConditionalStmt((Expression)$3, (Statement)$6);
			
			// add else:
			if ($8 != null)
				conditions.Add(new ConditionalStmt(null, (Statement)$8));
			
			$$ = new IfStmt(@$, conditions);
			
			LeaveConditionalCode();
	  }
		
	|	T_IF '(' expr ')' ':'  
		{ 
			EnterConditionalCode();
		}
		inner_statement_list_opt elseif_colon_list_opt else_colon_opt T_ENDIF ';' 
		{ 
			List<ConditionalStmt> conditions = (List<ConditionalStmt>)$8;
			conditions[0] = new ConditionalStmt((Expression)$3, new BlockStmt(@7, (List<Statement>)$7));
			
			// add else:
			if ($9 != null)
				conditions.Add(new ConditionalStmt(null, (Statement)$9));
			
			$$ = new IfStmt(@$, conditions);
			
			LeaveConditionalCode();
		}
		
	|	T_WHILE '(' expr ')' 
		{
			EnterConditionalCode();
		}
		while_statement 
		{ 
			$$ = new WhileStmt(@$, WhileStmt.Type.While, (Expression)$3, (Statement)$6); 
			LeaveConditionalCode();
		}
		
	|	T_DO statement T_WHILE '('  expr ')' ';' 
		{ 
			$$ = new WhileStmt(@$, WhileStmt.Type.Do, (Expression)$5, (Statement)$2); 
		}
	
	|	T_FOR '(' expression_list_opt ';' expression_list_opt ';' expression_list_opt ')' 
		{
			EnterConditionalCode();
		}
		for_statement 
		{ 
			$$ = new ForStmt(@$, (List<Expression>)$3, (List<Expression>)$5, (List<Expression>)$7, (Statement)$10); 
			LeaveConditionalCode();
		}
	
	|	T_SWITCH '(' expr ')'	 
		{
			EnterConditionalCode();
		}
		switch_case_list 
		{ 
			$$ = new SwitchStmt(@$, (Expression)$3, (List<SwitchItem>)$6); 
			LeaveConditionalCode();
		}
		
	|	T_BREAK ';'													{ $$ = new JumpStmt(@$, JumpStmt.Types.Break, null); }			
	|	T_BREAK expr ';'										{ $$ = new JumpStmt(@$, JumpStmt.Types.Break, (Expression)$2); }		
	|	T_CONTINUE ';'											{ $$ = new JumpStmt(@$, JumpStmt.Types.Continue, null); }			
	|	T_CONTINUE expr ';'									{ $$ = new JumpStmt(@$, JumpStmt.Types.Continue, (Expression)$2); }	
	|	T_RETURN ';'												{ $$ = new JumpStmt(@$, JumpStmt.Types.Return, null); }						
	|	T_RETURN expr ';'                   { $$ = new JumpStmt(@$, JumpStmt.Types.Return, (Expression)$2); }	
	|	T_GLOBAL global_var_list ';'        { $$ = new GlobalStmt(@$, (List<SimpleVarUse>)$2); }
	|	T_STATIC static_variable_list ';'   { $$ = new StaticStmt(@$, (List<StaticVarDecl>)$2); }
	|	T_ECHO expression_list ';'          { $$ = new EchoStmt(@$, (List<Expression>)$2); }
	|	T_INLINE_HTML                       
		{ 
			List<Expression> list = new List<Expression>(1); 
			list.Add(new StringLiteral(@$, (string)$1)); 
			$$ = new EchoStmt(@$, list); 
		}
	|	expression_statement { $$ = $1; }
	  
	|	T_UNSET '(' writable_chain_list ')' ';' 
	  { 
	    $$ = new UnsetStmt(@$, (List<VariableUse>)$3); 
	  }
	
	|	T_FOREACH '(' chain T_AS foreach_variable foreach_optional_arg ')' foreach_statement 
		{ 
			$$ = CreateForeachStmt(@$, (Expression)$3, (ForeachVar)$5, @5, (ForeachVar)$6, (Statement)$8);
		}
		
	|	T_FOREACH '(' expr_without_chain T_AS writable_chain foreach_optional_arg ')' foreach_statement 
		{ 
			$$ = CreateForeachStmt(@$, (Expression)$3, new ForeachVar((VariableUse)$5, false), @5, 
			  (ForeachVar)$6, (Statement)$8);
		}
	
	|	T_TRY
		{
			EnterConditionalCode();
		}
		'{' inner_statement_list_opt '}' T_CATCH '(' qualified_static_type_ref T_VARIABLE ')' 
		'{' inner_statement_list_opt '}' additional_catches_opt	
		{ 
			$$ = CreateTryStmt(@$, (List<Statement>)$4, @8, (GenericQualifiedName)$8, @9, (string)$9, (List<Statement>)$12, (List<CatchItem>)$14);
			LeaveConditionalCode();
		}
	
	|	T_THROW expr ';'		
		{ 
			$$ = new ThrowStmt(@$, (Expression)$2); 
		}
	
	|	T_GOTO identifier ';'
		{ 
			$$ = new GotoStmt(@$, (string)$2); /* PHP6 */ 
		}
;


additional_catches_opt:
		additional_catches	{ $$ = $1; }
	|	/* empty */					{ $$ = null; }
;

additional_catches:
		additional_catches T_CATCH '(' qualified_static_type_ref T_VARIABLE ')'  '{' inner_statement_list_opt '}' 
		{ 
			$$ = $1; 
			ListAdd<CatchItem>($$, new CatchItem(@4, (GenericQualifiedName)$4, new DirectVarUse(@5, (string)$5), (List<Statement>)$8)); 
		}
		
	|	T_CATCH '(' qualified_static_type_ref T_VARIABLE ')'  '{' inner_statement_list_opt '}'
		{
			$$ = NewList<CatchItem>(new CatchItem(@4, (GenericQualifiedName)$3, new DirectVarUse(@4, (string)$4), (List<Statement>)$7));
		} 
;

reference_opt:
		/* empty */	{ $$ = 0; }
	|	'&'					{ $$ = 1; }
;


foreach_optional_arg:
		/* empty */											{ $$ = null; }
	|	T_DOUBLE_ARROW foreach_variable	{ $$ = $2; }
;

foreach_variable:
	reference_opt writable_chain    { $$ = new ForeachVar((VariableUse)$2, $1 == 1); }	
;

for_statement:
		statement															    { $$ = $1; }
	|	':' inner_statement_list_opt T_ENDFOR ';' { $$ = new BlockStmt(@2, (List<Statement>)$2); }
;

foreach_statement:
		statement																	    { $$ = $1; }
	|	':' inner_statement_list_opt T_ENDFOREACH ';' { $$ = new BlockStmt(@2, (List<Statement>)$2); }
;

switch_case_list:
		'{' case_list_opt '}'									{ $$ = $2; }
	|	'{' ';' case_list_opt '}'							{ $$ = $3; }
	|	':' case_list_opt T_ENDSWITCH ';'			{ $$ = $2; }
	|	':' ';' case_list_opt T_ENDSWITCH ';'	{ $$ = $3; }
;

case_list_opt:
		/* empty */	
		{ 
		  $$ = new List<SwitchItem>(); 
		}
		
	|	case_list_opt T_CASE expr case_separator inner_statement_list_opt
		{ 
		  $$ = $1; 
		  ListAdd<SwitchItem>($$, new CaseItem(@2, (Expression)$3, (List<Statement>)$5)); 
		}
		  
	|	case_list_opt T_DEFAULT case_separator  inner_statement_list_opt 
		{	
		  $$ = $1; 
		  ListAdd<SwitchItem>($$, new DefaultItem(@2, (List<Statement>)$4)); 
		}
;


case_separator:
		':'
	|	';'
;


while_statement:
		statement																    { $$ = $1; }
	|	':' inner_statement_list_opt T_ENDWHILE ';' { $$ = new BlockStmt(@2, (List<Statement>)$2); }
;



elseif_list_opt:
		/* empty */ 
		{ 
			// initialize list with the first item reserved for the if-condition and the true-statement pair:
			$$ = NewList<ConditionalStmt>(null);
		}
	|	elseif_list_opt T_ELSEIF '(' expr ')' statement
		{ 
			$$ = $1; 
			ListAdd<ConditionalStmt>($$, new ConditionalStmt((Expression)$4, (Statement)$6)); 
		}
;


elseif_colon_list_opt:
		/* empty */ 
		{ 
		  $$ = NewList<ConditionalStmt>(null);
		}
	|	elseif_colon_list_opt T_ELSEIF '(' expr ')' ':' inner_statement_list_opt 
		{ 
			$$ = $1;
			ListAdd<ConditionalStmt>($$, new ConditionalStmt((Expression)$4, new BlockStmt(@7, (List<Statement>)$7))); 
		}
;


else_opt:
		/* empty */				{ $$ = null; }
	|	T_ELSE statement	{ $$ = $2; }
;


else_colon_opt:
		/* empty */									        { $$ = null; }
	|	T_ELSE ':' inner_statement_list_opt { $$ = new BlockStmt(@3, (List<Statement>)$3); }
;


formal_parameter_list_opt: 
		formal_parameter_list	{ $$ = $1; }
	|	/* empty */			      { $$ = emptyFormalParamListIndex; }
;

formal_parameter_list:
		formal_parameter	
		{ 
		  $$ = NewList<FormalParam>($1); 
		}
			
	|	formal_parameter_list ',' formal_parameter
		{ 
		  $$ = $1; 
		  ListAdd<FormalParam>($$, $3); 
		}	
;

formal_parameter:         
    attributes_opt type_hint_opt reference_opt T_VARIABLE                   
    { 
			$$ = new FormalParam(@4, (string)$4, $2, $3 == 1, null, (List<CustomAttribute>)$1); 
		}
  | attributes_opt type_hint_opt reference_opt T_VARIABLE '=' constant_inititalizer 
		{ 
			$$ = new FormalParam(@4, (string)$4, $2, $3 == 1, (Expression)$6, (List<CustomAttribute>)$1); 
		}
;

type_hint_opt:
		/* empty */                { $$ = null; }	
	|	qualified_static_type_ref  { $$ = $1; } 
	|	primitive_type             { $$ = $1; }
;


actual_arguments_opt:
		generic_dynamic_args_opt '(' actual_argument_list_opt ')' { $$ = new Pair($1, $3); }
	|	/* empty */                                               { $$ = null; }
;

actual_argument_list_opt:
		actual_argument_list	     { $$ = $1; }
	|	/* empty */								 { $$ = emptyActualParamListIndex; }			
;

actual_argument_list:
	  actual_argument_list ',' actual_argument	
		{ 
		  $$ = $1; 
		  ListAdd<ActualParam>($$, $3);
		}
	| actual_argument	
		{ 
			$$ = NewList<ActualParam>($1);
		}
;

actual_argument:
    expr
    {
			$$ = new ActualParam(@$, (Expression)$1, false);
    }
  | '&' writable_chain 
    {
      // deprecated; only for error reporting
      $$ = new ActualParam(CombinePositions(@1, @2), (Expression)$2, true);
    }
;

global_var_list:
		global_var_list ',' global_var	
		{ 
		  $$ = $1; 
		  ListAdd<SimpleVarUse>($$, $3); 
		}
	|	global_var	
	  { 
		  $$ = NewList<SimpleVarUse>($1);
	  }					
;


global_var:
		T_VARIABLE				{ $$ = new DirectVarUse(@$, (string)$1); }		
	|	'$' chain         { $$ = new IndirectVarUse(@$, 1, (VarLikeConstructUse)$2); }
	|	'$' '{' expr '}'	{ $$ = new IndirectVarUse(@$, 1, (Expression)$3); }
;


static_variable_list:
		static_variable_list ',' static_variable 
		{ 
			$$ = $1; 
			ListAdd<StaticVarDecl>($$, $3); 
		}
			
	|	static_variable
		{ 
			$$ = NewList<StaticVarDecl>($1); 
		}
;

static_variable:
	  T_VARIABLE                      
	  { 
			$$ = new StaticVarDecl(@1, new DirectVarUse(@1, (string)$1), null); 
	  }
	  
	| T_VARIABLE '=' constant_inititalizer    
	  { 
			$$ = new StaticVarDecl(CombinePositions(@1, @3), new DirectVarUse(@1, (string)$1), (Expression)$3); 
		}
;


class_statement_list_opt:
		class_statement_list_opt class_statement  { $$ = $1; ListAdd<TypeMemberDecl>($$, $2); }
	|	/* empty */														    { $$ = new List<TypeMemberDecl>(); }
;


class_statement:
		attributes_opt property_modifiers property_declarator_list ';'			
		{ 
			$$ = new FieldDeclList(@$, (PhpMemberAttributes)$2, (List<FieldDecl>)$3, (List<CustomAttribute>)$1); 
			
			CommentSet cs = new CommentSet(new Comment[] {new Comment(CommentType.Documentation, CommentPosition.Before, PopDocComment())} );
			  
			($$ as LangElement).Annotations.Set<CommentSet>(cs); 
		}
		 
	|	attributes_opt class_constant_declarator_list ';'
		{ 
		  $$ = new ConstDeclList(@$, (List<ClassConstantDecl>)$2, (List<CustomAttribute>)$1);
		  
		  CommentSet cs = new CommentSet(new Comment[] {new Comment(CommentType.Documentation, CommentPosition.Before, PopDocComment())} );
			  
		  ($$ as LangElement).Annotations.Set<CommentSet>(cs);
		}
		
	|	attributes_opt member_modifiers_opt T_FUNCTION attributes_opt reference_opt class_method_identifier 
	  type_parameter_list_opt '(' formal_parameter_list_opt ')' 
		base_ctor_call_opt
		{
			EnterConditionalCode();
		}
		method_body
		{ 
			CheckTypeParameterNames((List<FormalTypeParam>)$7, null);
		  
			$$ = new MethodDecl(@6, @$, GetHeadingEnd(GetLeftValidPosition(11)),GetBodyStart(@13), (string)$6, $5 != 0, (List<FormalParam>)$9, (List<FormalTypeParam>)$7,
				(List<Statement>)$13, (PhpMemberAttributes)$2, (List<ActualParam>)$11, (List<CustomAttribute>)$1,
				(List<CustomAttribute>)$4); 
				
			CommentSet cs = new CommentSet(new Comment[] {new Comment(CommentType.Documentation, CommentPosition.Before, (string)$3)} );
			  
			($$ as LangElement).Annotations.Set<CommentSet>(cs);
			
			LeaveConditionalCode();
		} 
;

class_method_identifier:
	identifier { $$ = $1; }
	|
	T_ASSERT { $$ = "assert"; }
;

base_ctor_call_opt:
	  /* empty */     { $$ = null; }
	| ':' identifier '(' actual_argument_list_opt ')'
	  {
	    if (!Name.ParentClassName.Equals((string)$2))
				errors.Add(Errors.ExpectingParentCtorInvocation, SourceUnit, @2);
	    
	    $$ = $4;
	  }
;


method_body:
		';' /* abstract method */			{ $$ = null; }
	|	'{' inner_statement_list_opt '}'	{ $$ = $2; }
;

property_modifiers:
		member_modifiers	{ $$ = $1; }
	|	T_VAR						  { $$ = (int)PhpMemberAttributes.Public; PushDocComment($1); }
;

member_modifiers_opt:
		/* empty */				{ $$ = (int)PhpMemberAttributes.Public; }
	|	member_modifiers	{ $$ = $1; }
;

member_modifiers:
		member_modifier															
		{ 
			$$ = $1; 
		}
	|	member_modifiers member_modifier	
		{ 
		  if (($1 & (int)PhpMemberAttributes.VisibilityMask) != 0 && ($2 & (int)PhpMemberAttributes.VisibilityMask) != 0)
		  {
		    errors.Add(Errors.MultipleVisibilityModifiers, SourceUnit, @2);
		  }
		  else
		  {
		    $$ = $1 | $2;
		  }  
		}
;
                   
member_modifier:
		T_PUBLIC			{ $$ = (int)PhpMemberAttributes.Public; }
	|	T_PROTECTED		{ $$ = (int)PhpMemberAttributes.Protected; }		
	|	T_PRIVATE			{ $$ = (int)PhpMemberAttributes.Private; }	
	|	T_STATIC			{ $$ = (int)PhpMemberAttributes.Static; }	
	|	T_ABSTRACT		{ $$ = (int)PhpMemberAttributes.Abstract; }		
	|	T_FINAL				{ $$ = (int)PhpMemberAttributes.Final; }	
;

property_declarator_list:
		property_declarator_list ',' property_declarator			
		{ 
			$$ = $1; 
			ListAdd<FieldDecl>($$, $3); 
		}
		
	|	property_declarator		
		{ 
			$$ = NewList<FieldDecl>($1);
		}
;

property_declarator:
    T_VARIABLE
    {
			$$ = new FieldDecl(@1, (string)$1, null);
    }
    
  | T_VARIABLE '=' constant_inititalizer
    {
			$$ = new FieldDecl(@1, (string)$1, (Expression)$3);
    }
;

class_constant_declarator_list:
		class_constant_declarator_list ',' class_constant_declarator
		{ 
		  $$ = $1; 
		  ListAdd<ClassConstantDecl>($$, $3); 
		}
		
	|	T_CONST class_constant_declarator
		{ 
			$$ = NewList<ClassConstantDecl>($2); 
			PushDocComment($1);
		}
;

class_constant_declarator:
  identifier '=' constant_inititalizer 
  { 
    $$ = new ClassConstantDecl(@1, (string)$1, CheckInitializer(@3, (Expression)$3)); 
  }
;

global_constant_declarator_list:
		global_constant_declarator_list ',' global_constant_declarator
		{ 
			$$ = $1;
			ListAdd<GlobalConstantDecl>($1, $3);
		}
	|	T_CONST global_constant_declarator
		{ 
			$$ = NewList<GlobalConstantDecl>($2);
			PushDocComment($1);
		}
;

global_constant_declarator:
  identifier '=' constant_inititalizer
  {
    GlobalConstantDecl c = new GlobalConstantDecl(sourceUnit, @1, IsCurrentCodeConditional, GetScope(), 
				(string)$1, currentNamespace, (Expression)$3);

		reductionsSink.GlobalConstantDeclarationReduced(this, c);
		
		$$ = c;
  }
;  

global_constant_declaration_statement:
	attributes_opt global_constant_declarator_list   
  { 
	  $$ = new GlobalConstDeclList(@$, (List<GlobalConstantDecl>)$2, (List<CustomAttribute>)$1, PopDocComment()); 
	}
;

expression_list:	
		expression_list ',' expr 
		{ 
			ListAdd<Expression>($1, $3);
			$$ = $1; 
		}
	|	expr	
		{ 
			$$ = NewList<Expression>($1);
		}				
;


expression_list_opt:
		/* empty */		  { $$ = emptyExpressionListIndex; }
	|	expression_list	{ $$ = $1; }
;

expr:
		chain			          { $$ = $1; }			
	|	expr_without_chain	{ $$ = $1; }
;

assignment_expression:
		writable_chain '=' expr	         { $$ = new ValueAssignEx(@$, Operations.AssignValue, (VariableUse)$1, (Expression)$3); }	
	|	writable_chain '=' '&' chain  { $$ = new RefAssignEx(@$, (VariableUse)$1, (VarLikeConstructUse)$4); }
		
	|	writable_chain '=' '&' T_NEW type_ref ctor_arguments_opt 
		{  
			$$ = new RefAssignEx(@$, (VariableUse)$1, new NewEx(CombinePositions(@4, @6), (TypeRef)$5, (List<ActualParam>)$6)); 
		}
	|	writable_chain T_PLUS_EQUAL expr { $$ = new ValueAssignEx(@$, Operations.AssignAdd, (VariableUse)$1, (Expression)$3); }
	|	writable_chain T_MINUS_EQUAL expr	{ $$ = new ValueAssignEx(@$, Operations.AssignSub, (VariableUse)$1, (Expression)$3); }
	|	writable_chain T_MUL_EQUAL expr	{ $$ = new ValueAssignEx(@$, Operations.AssignMul, (VariableUse)$1, (Expression)$3); 	}
	|	writable_chain T_DIV_EQUAL expr	{ $$ = new ValueAssignEx(@$, Operations.AssignDiv, (VariableUse)$1, (Expression)$3); }	
	|	writable_chain T_CONCAT_EQUAL expr { $$ = new ValueAssignEx(@$, Operations.AssignAppend, (VariableUse)$1, (Expression)$3); }	
	|	writable_chain T_MOD_EQUAL expr	{ $$ = new ValueAssignEx(@$, Operations.AssignMod, (VariableUse)$1, (Expression)$3); }	
	|	writable_chain T_AND_EQUAL expr	{ $$ = new ValueAssignEx(@$,Operations.AssignAnd, (VariableUse)$1, (Expression)$3); }	
	|	writable_chain T_OR_EQUAL expr { $$ = new ValueAssignEx(@$, Operations.AssignOr, (VariableUse)$1, (Expression)$3); }		
	|	writable_chain T_XOR_EQUAL expr	{ $$ = new ValueAssignEx(@$, Operations.AssignXor, (VariableUse)$1, (Expression)$3); }		
	|	writable_chain T_SL_EQUAL expr { $$ = new ValueAssignEx(@$, Operations.AssignShiftLeft, (VariableUse)$1, (Expression)$3); }	 
	|	writable_chain T_SR_EQUAL expr { $$ = new ValueAssignEx(@$, Operations.AssignShiftRight, (VariableUse)$1, (Expression)$3); } 
;

expr_without_chain:	
		assignment_expression 
		{ 
			$$ = $1; 
		}
		
	|	T_NEW type_ref ctor_arguments_opt 
		{ 
			$$ = new NewEx(@$, (TypeRef)$2, (List<ActualParam>)$3); 
		}
		
	|	T_CLONE expr                    { $$ = new UnaryEx(@$, Operations.Clone, (Expression)$2); }
		
	|	writable_chain T_INC                { $$ = new IncDecEx(@$, true, true, (VariableUse)$1); }
	|	T_INC writable_chain                { $$ = new IncDecEx(@$, true, false, (VariableUse)$2); }
	|	writable_chain T_DEC                { $$ = new IncDecEx(@$, false, true, (VariableUse)$1); }
	|	T_DEC writable_chain                { $$ = new IncDecEx(@$, false, false, (VariableUse)$2); }

	|	'+' expr                        { $$ = new UnaryEx(@$, Operations.Plus, (Expression)$2); }
	|	'-' expr                        { $$ = new UnaryEx(@$, Operations.Minus, (Expression)$2); }
	|	'!' expr                        { $$ = new UnaryEx(@$, Operations.LogicNegation, (Expression)$2); }
	|	'~' expr                        { $$ = new UnaryEx(@$, Operations.BitNegation, (Expression)$2); }
  | cast_operation expr             { $$ = new UnaryEx(@$, (Operations)$1, (Expression)$2); } %prec TypeCast
	|	T_PRINT expr										{ $$ = new UnaryEx(@$, Operations.Print, (Expression)$2); }
	|	'@' expr						            { $$ = new UnaryEx(@$, Operations.AtSign, (Expression)$2); }
	
	|	expr T_BOOLEAN_OR  expr         { $$ = new BinaryEx(@$, Operations.Or, (Expression)$1, (Expression)$3); }
	|	expr T_BOOLEAN_AND  expr        { $$ = new BinaryEx(@$, Operations.And, (Expression)$1, (Expression)$3); } 
	|	expr T_LOGICAL_OR  expr         { $$ = new BinaryEx(@$, Operations.Or, (Expression)$1, (Expression)$3); }
	|	expr T_LOGICAL_AND  expr        { $$ = new BinaryEx(@$, Operations.And, (Expression)$1, (Expression)$3); }
	|	expr T_LOGICAL_XOR expr         { $$ = new BinaryEx(@$, Operations.Xor, (Expression)$1, (Expression)$3); }
	|	expr '|' expr	                  { $$ = new BinaryEx(@$, Operations.BitOr, (Expression)$1, (Expression)$3); }
	|	expr '&' expr	                  { $$ = new BinaryEx(@$, Operations.BitAnd, (Expression)$1, (Expression)$3); }
	|	expr '^' expr	                  { $$ = new BinaryEx(@$, Operations.BitXor, (Expression)$1, (Expression)$3); }
//	|	expr '.' expr                   { $$ = new BinaryEx(@$, Operations.Concat, (Expression)$1, (Expression)$3); }		// we are using concat_exprs to chain the concatenation
	|	concat_exprs					{ $$ = new ConcatEx(@$, new List<Expression>((List<Expression>)$1)); }
	|	expr '+' expr                   { $$ = new BinaryEx(@$, Operations.Add, (Expression)$1, (Expression)$3); }
	|	expr '-' expr                   { $$ = new BinaryEx(@$, Operations.Sub, (Expression)$1, (Expression)$3); }	
	|	expr '*' expr	                  { $$ = new BinaryEx(@$, Operations.Mul, (Expression)$1, (Expression)$3); }
	|	expr '/' expr	                  { $$ = new BinaryEx(@$, Operations.Div, (Expression)$1, (Expression)$3); }
	|	expr '%' expr 	                { $$ = new BinaryEx(@$, Operations.Mod, (Expression)$1, (Expression)$3); }
	| expr T_SL expr	                { $$ = new BinaryEx(@$, Operations.ShiftLeft, (Expression)$1, (Expression)$3); }
	|	expr T_SR expr	                { $$ = new BinaryEx(@$, Operations.ShiftRight, (Expression)$1, (Expression)$3); }
	|	expr T_IS_IDENTICAL expr				{ $$ = new BinaryEx(@$, Operations.Identical, (Expression)$1, (Expression)$3); }	
	|	expr T_IS_NOT_IDENTICAL expr		{ $$ = new BinaryEx(@$, Operations.NotIdentical, (Expression)$1, (Expression)$3); }
	|	expr T_IS_EQUAL expr						{ $$ = new BinaryEx(@$, Operations.Equal, (Expression)$1, (Expression)$3); }
	|	expr T_IS_NOT_EQUAL expr 				{ $$ = new BinaryEx(@$, Operations.NotEqual, (Expression)$1, (Expression)$3); }
	|	expr '<' expr 									{ $$ = new BinaryEx(@$, Operations.LessThan, (Expression)$1, (Expression)$3); }
	|	expr T_IS_SMALLER_OR_EQUAL expr { $$ = new BinaryEx(@$, Operations.LessThanOrEqual, (Expression)$1, (Expression)$3); }
	|	expr '>' expr 									{ $$ = new BinaryEx(@$, Operations.GreaterThan, (Expression)$1, (Expression)$3); }
	|	expr T_IS_GREATER_OR_EQUAL expr { $$ = new BinaryEx(@$, Operations.GreaterThanOrEqual, (Expression)$1, (Expression)$3); }
	|	expr T_INSTANCEOF type_ref      { $$ = new InstanceOfEx(@$, (Expression)$1, (TypeRef)$3); }
	|	T_TYPEOF type_ref               { $$ = new TypeOfEx(@$, (TypeRef)$2); } // not enclosed in parenthesis to prevent conflicts with casts. e.g clrtypeof(int)
	|	'(' expr ')'                    { $$ = $2;}
	|	expr '?' expr ':' expr          { $$ = new ConditionalEx(@$, (Expression)$1, (Expression)$3, (Expression)$5); }
	
	| T_LIST '(' assignment_list ')' '=' expr { $$ = new ListEx(@$, (List<Expression>)$3, (Expression)$6); }
	|	T_ARRAY '(' array_item_list_opt ')'     { $$ = new ArrayEx(@$, (List<Item>)$3); }
	|	T_ISSET '(' writable_chain_list ')'     { $$ = new IssetEx(@$, (List<VariableUse>)$3); }
	|	T_EMPTY '(' chain ')'				            { CheckVariableUse(@3, $3); $$ = new EmptyEx(@$, (VariableUse)$3); }		
	|	T_EVAL '(' expr ')'                     { $$ = new EvalEx(@$, (Expression)$3, false); }
	| T_ASSERT '(' expr ')'                   { $$ = new EvalEx(@$, (Expression)$3, true); }
	|	T_EXIT exit_expr_opt		                { $$ = new ExitEx(@$, (Expression)$2); }
	|	scalar_expr                             { $$ = $1; }			
	|	'`' composite_string_opt '`'						{ $$ = new ShellEx(@$, CreateConcatExOrStringLiteral(CombinePositions(@1, @3), (List<Expression>)$2, false)); }

	|	T_INCLUDE expr 									{ $$ = new IncludingEx(sourceUnit, GetScope(), IsCurrentCodeConditional, @$, InclusionTypes.Include, (Expression)$2); reductionsSink.InclusionReduced(this, (IncludingEx)$$); }
	|	T_INCLUDE_ONCE expr             { $$ = new IncludingEx(sourceUnit, GetScope(), IsCurrentCodeConditional, @$, InclusionTypes.IncludeOnce, (Expression)$2); reductionsSink.InclusionReduced(this, (IncludingEx)$$); }
	|	T_REQUIRE expr		              { $$ = new IncludingEx(sourceUnit, GetScope(), IsCurrentCodeConditional, @$, InclusionTypes.Require, (Expression)$2); reductionsSink.InclusionReduced(this, (IncludingEx)$$); }
	|	T_REQUIRE_ONCE expr		          { $$ = new IncludingEx(sourceUnit, GetScope(), IsCurrentCodeConditional, @$, InclusionTypes.RequireOnce, (Expression)$2); reductionsSink.InclusionReduced(this, (IncludingEx)$$); }

	| linq_query_expression           { $$ = $1; }
;

concat_exprs:
		concat_exprs '.' expr	{ $$ = new List<Expression>((List<Expression>)$1){ (Expression)$3 }; }
	|	expr '.' expr			{ $$ = new List<Expression>(){ (Expression)$1, (Expression)$3 }; }
;

cast_operation:
    T_BOOL_CAST                 { $$ = (int)Operations.BoolCast; }
  | T_INT8_CAST                 { $$ = (int)Operations.Int8Cast; }
  | T_INT16_CAST                { $$ = (int)Operations.Int16Cast; }
  | T_INT32_CAST                { $$ = (int)Operations.Int32Cast; }
  | T_INT64_CAST                { $$ = (int)Operations.Int64Cast; }
  | T_UINT8_CAST                { $$ = (int)Operations.UInt8Cast; }
  | T_UINT16_CAST               { $$ = (int)Operations.UInt16Cast; }
  | T_UINT32_CAST               { $$ = (int)Operations.UInt32Cast; }
  | T_UINT64_CAST               { $$ = (int)Operations.UInt64Cast; }
  | T_DOUBLE_CAST               { $$ = (int)Operations.DoubleCast; }
  | T_FLOAT_CAST                { $$ = (int)Operations.FloatCast; }
  | T_DECIMAL_CAST              { $$ = (int)Operations.DecimalCast; }
  | T_STRING_CAST               { $$ = (int)Operations.StringCast; }
  | T_BINARY_CAST               { $$ = (int)Operations.BinaryCast; }
  | T_UNICODE_CAST              { $$ = (int)Operations.UnicodeCast; }
  | T_ARRAY_CAST                { $$ = (int)Operations.ArrayCast; }
  | T_OBJECT_CAST               { $$ = (int)Operations.ObjectCast; }
  | T_UNSET_CAST                { $$ = (int)Operations.UnsetCast; }
;

linq_query_expression:
    linq_from_clause linq_query_body 
    { 
      $$ = new LinqExpression(@$, (FromClause)$1, (QueryBody)$2);
      scanner.LeaveLinq();
    }
;
  
linq_from_clause: 
    T_LINQ_FROM { scanner.EnterLinq(); } linq_generator_list 
    { 
      $$ = new FromClause(@$, (List<Generator>)$3); 
    }
;

linq_generator_list:
    linq_generator_list ',' linq_generator { $$ = $1; ListAdd<Generator>($$, $3); }
  | linq_generator                         { $$ = NewList<Generator>($1); }
;  

linq_generator:
    expr T_AS T_VARIABLE 
    {
      $$ = new Generator(@$, (Expression)$1, null, new DirectVarUse(@3, (string)$3));
    }
  | expr T_AS T_VARIABLE T_DOUBLE_ARROW T_VARIABLE 
    {
      $$ = new Generator(@$, (Expression)$1, new DirectVarUse(@3, (string)$3), new DirectVarUse(@5, (string)$5)); 
    }
;

linq_query_body:
    linq_from_where_clause_list_opt
    linq_orderby_clause_opt
    linq_select_groupby_clause
    linq_into_clause_opt 
    { 
      $$ = new QueryBody((List<FromWhereClause>)$1, (OrderByClause)$2, $3, (IntoClause)$4);
    }
;

linq_from_where_clause_list_opt:
    /* empty */                                       { $$ = new List<FromWhereClause>(); }
  | linq_from_where_clause_list_opt linq_from_clause  { $$ = $1; ListAdd<FromWhereClause>($$, $2); }
  | linq_from_where_clause_list_opt linq_where_clause { $$ = $1; ListAdd<FromWhereClause>($$, $2); }
;

linq_where_clause: 
    T_LINQ_WHERE expr { $$ = new WhereClause(@$, (Expression)$2); }
;                     

linq_orderby_clause_opt:
    /* empty */                                 { $$ = null; }
  | T_LINQ_ORDERBY linq_ordering_list           { $$ = new OrderByClause(@$, (List<OrderingClause>)$2); }
;

linq_ordering_list:
    linq_ordering_list ',' linq_ordering_clause { $$ = $1; ListAdd<OrderingClause>($$, $3); }
  | linq_ordering_clause                        { $$ = NewList<OrderingClause>($1); }
;

linq_ordering_clause:
    expr                   { $$ = new OrderingClause(@$, (Expression)$1, Ordering.Default); }                   
  | expr T_LINQ_DESCENDING { $$ = new OrderingClause(@$, (Expression)$1, Ordering.Descending); } 
  | expr T_LINQ_ASCENDING  { $$ = new OrderingClause(@$, (Expression)$1, Ordering.Ascending); }  
;  
    
linq_select_groupby_clause:
    T_LINQ_SELECT expr               { $$ = new SelectClause(@$, (Expression)$2); }
  | T_LINQ_GROUP expr T_LINQ_BY expr { $$ = new GroupByClause(@$, (Expression)$2, (Expression)$4); }
;  

linq_into_clause_opt:
    /* empty */ 
    { 
      $$ = null; 
    }
  | T_AS T_VARIABLE T_LINQ_IN linq_query_body 
    { 
      DirectVarUse value_var = new DirectVarUse(@2, (string)$2);
      QueryBody body = (QueryBody)$4;
      
      $$ = new IntoClause(@$, null, value_var, body); 
    }
  | T_AS T_VARIABLE T_DOUBLE_ARROW T_VARIABLE T_LINQ_IN linq_query_body 
    { 
      DirectVarUse key_var = new DirectVarUse(@2, (string)$2);
      DirectVarUse value_var = new DirectVarUse(@4, (string)$4);
      QueryBody body = (QueryBody)$6;
      
      $$ = new IntoClause(@$, key_var, value_var, body); 
    }  
;

function_call:
		namespace_name generic_dynamic_args_opt '(' actual_argument_list_opt ')' 
		{ 
		  $$ = new DirectFcnCall(@$, (QualifiedName)$1, (List<ActualParam>)$4, (List<TypeRef>)$2); 
		}

	|	class_constant generic_dynamic_args_opt '(' actual_argument_list_opt ')' 
		{ 
		  $$ = new DirectStMtdCall(@$, (ClassConstUse)$1, (List<ActualParam>)$4, (List<TypeRef>)$2); 
		}
		
	|	qualified_static_type_ref T_DOUBLE_COLON keyed_variable generic_dynamic_args_opt '(' actual_argument_list_opt ')' 
		{ 
		  $$ = new IndirectStMtdCall(@$, (GenericQualifiedName)$1, (CompoundVarUse)$3, (List<ActualParam>)$6, 
				(List<TypeRef>)$4);	
		}
		
	|	keyed_variable generic_dynamic_args_opt '(' actual_argument_list_opt ')' 
		{ 
		  $$ = new IndirectFcnCall(@$, (CompoundVarUse)$1, (List<ActualParam>)$4, (List<TypeRef>)$2); 
		}
			
;

qualified_static_type_ref:
		namespace_name generic_dynamic_args_opt
		{ 
			$$ = new GenericQualifiedName((QualifiedName)$1, TypeRef.ToStaticTypeRefs((List<TypeRef>)$2, errors, sourceUnit)); 
		}
;

type_ref:
		namespace_name generic_dynamic_args_opt
		{ 
			$$ = new DirectTypeRef(@$, (QualifiedName)$1, (List<TypeRef>)$2);
		}
		
	|	indirect_type_ref generic_dynamic_args_opt
		{ 
			$$ = new IndirectTypeRef(@$, (VariableUse)$1, (List<TypeRef>)$2); 
		}
	
	|	primitive_type
		{ 
			$$ = new PrimitiveTypeRef(@$, (PrimitiveType)$1); 
		}
;

type_ref_list:
		type_ref					
		{ 
			$$ = NewList<TypeRef>($1);
		}		
		
	|	type_ref_list ',' type_ref	
		{ 
			$$ = $1; 
			ListAdd<TypeRef>($$, $3); 
		}
;	


indirect_type_ref:
		chain_base T_OBJECT_OPERATOR keyed_field_name keyed_field_names_opt 
		{ 
			((VarLikeConstructUse)$3).IsMemberOf = (VariableUse)$1; 
			if ($4 != null) 
			{ 
				((VarLikeConstructUse)$4).IsMemberOf = (VarLikeConstructUse)$3; 
				$$ = $4;
			} 
			else 
			{
			  $$ = $3;
			}   
		}
			
	|	chain_base 
	  { 
	    $$ = $1; 
	  }
;

namespace_name:   	 
		T_NAMESPACE_NAME  { $$ = new QualifiedName((List<string>)$1, true); }
	|	identifier        { $$ = new QualifiedName((string)$1, true); }
;

keyed_field_names_opt:
		keyed_field_names_opt T_OBJECT_OPERATOR keyed_field_name
		{ 
			if ($1 != null) ((VariableUse)$3).IsMemberOf = (VarLikeConstructUse)$1; 
			$$ = $3; 
		}  
		
	|	/* empty */ { $$ = null; }
;

exit_expr_opt:
		/* empty */		{ $$ = null; }
	|	'(' ')'				{ $$ = null; }
	|	'(' expr ')'	{ $$ = $2; }
;


ctor_arguments_opt:
		/* empty */														{ $$ = emptyActualParamListIndex; }	
	|	'(' actual_argument_list_opt ')'	{ $$ = $2; }
;

constant_inititalizer:
	  constant                                  { $$ = $1; }
	|	T_ARRAY '(' constant_array_item_list_opt ')'	{ $$ = new ArrayEx(@$, (List<Item>)$3); }
	|	'+' constant_inititalizer	                { $$ = new UnaryEx(@$, Operations.Plus, (Expression)$2); }
	|	'-' constant_inititalizer	                { $$ = new UnaryEx(@$, Operations.Minus, (Expression)$2); }
;

constant:
		literal_constant			      { $$ = $1; }	
	| pseudo_constant             { $$ = $1; }
	|	class_constant		          { $$ = $1; }
	|	global_constant		          { $$ = $1; }
;

literal_constant:
		T_LNUMBER					{ $$ = new IntLiteral(@$, $1); }					
	|	T_L64NUMBER					{ $$ = new LongIntLiteral(@$, $1); }
	|	T_DNUMBER					{ $$ = new DoubleLiteral(@$, $1); }					
	|	T_CONSTANT_ENCAPSED_STRING	{ $$ = ($1 is string) ? (Literal)new StringLiteral(@$, (string)$1) : (Literal)new BinaryStringLiteral(@$, new PhpBytes((byte[])$1)); }	
;

pseudo_constant:
	  T_LINE 			                { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.Line); }				
	|	T_FILE 			                { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.File); }		
	|	T_DIR 			                { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.Dir); }		
	|	T_CLASS_C		                { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.Class); }	
	|	T_METHOD_C	                { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.Method); }		
	|	T_FUNC_C		                { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.Function); }				
	|	T_NAMESPACE_C	              { $$ = new PseudoConstUse(@$, PseudoConstUse.Types.Namespace); }
;

global_constant:
	namespace_name                { $$ = new GlobalConstUse(@$, (QualifiedName)$1); }
;

class_constant:
	qualified_static_type_ref T_DOUBLE_COLON identifier 
	{ 
	  $$ = new ClassConstUse(@$, (GenericQualifiedName)$1, (string)$3); 
	}
;

scalar_expr:
	  constant		      { $$ = $1; }
	|	T_STRING_VARNAME	{ $$ = new StringLiteral(@$, scanner.GetEncapsedString($1.Offset, $1.Integer)); }
	|	'"'               { scanner.InUnicodeString = unicodeSemantics; } composite_string_opt '"' { $$ = CreateConcatExOrStringLiteral(@$, (List<Expression>)$3, false); }	
	|	T_BINARY_DOUBLE   { scanner.InUnicodeString = unicodeSemantics; } composite_string_opt '"' { $$ = CreateConcatExOrStringLiteral(@$, (List<Expression>)$3, false); }
	|	T_START_HEREDOC   { scanner.InUnicodeString = false; } composite_string_opt T_END_HEREDOC  { $$ = CreateConcatExOrStringLiteral(@$, (List<Expression>)$3, true); }
	|	T_BINARY_HEREDOC  { scanner.InUnicodeString = false; } composite_string_opt T_END_HEREDOC  { $$ = CreateConcatExOrStringLiteral(@$, (List<Expression>)$3, true); }
;


writable_chain_list:
	  writable_chain_list ',' writable_chain	
		{ 
			$$ = $1; 
			ListAdd<VariableUse>($$, $3); 
		}
	|	writable_chain											
		{ 
			$$ = NewList<VariableUse>($1); 
		}
;

writable_chain:
	chain	{ CheckVariableUse(@1, $1); $$ = $1; }
;

chain:
		chain_base_with_function_calls T_OBJECT_OPERATOR keyed_field_name actual_arguments_opt member_access_chain_opt 
		{ 
      $$ = CreateVariableUse(@$, (VarLikeConstructUse)$1, (VarLikeConstructUse)$3, (Pair)$4, (VarLikeConstructUse)$5);
		}	
			
	|	chain_base_with_function_calls { $$ = $1; }	
;

member_access_chain_opt:
		member_access_chain_opt member_access 
		{ 
			$$ = CreatePropertyVariables((VarLikeConstructUse)$1, (VarLikeConstructUse)$2);
		}  
	|	/* empty */	{ $$ = null; }
;

// -> (identifier|{expr})[key_opt]* (<:type_args:>(args))?
// -> ($)*(T_VARIABLE|${expr})[key_opt]* (<:type_args:>(args))?
member_access:
		T_OBJECT_OPERATOR keyed_field_name actual_arguments_opt 
		{ 
      $$ = CreatePropertyVariable(@$, (CompoundVarUse)$2, (Pair)$3);
		}
;


key_opt:
		/* empty */	{ $$ = null; }	
	|	expr				{ $$ = $1; }		
;


// (T_VARIABLE|${expr})
compound_variable:
		T_VARIABLE				{ $$ = new DirectVarUse(@$, (string)$1);}
	|	'$' '{' expr '}'	{ $$ = new IndirectVarUse(@$, 1, (Expression)$3); }
;

// (T_VARIABLE|${expr})[key_opt]*
keyed_compound_variable:
		keyed_compound_variable '[' key_opt ']'	         { $$ = new ItemUse(@$, (CompoundVarUse)$1, (Expression)$3); }
	|	keyed_compound_variable '{' expr '}'				     { $$ = new ItemUse(@$, (CompoundVarUse)$1, (Expression)$3); }
	|	compound_variable										             { $$ = $1;}
;

// ($)*(T_VARIABLE|${expr})[key_opt]*
keyed_variable:
		keyed_compound_variable														{ $$ = $1; }
	|	simple_indirect_reference keyed_compound_variable	{ $$ = new IndirectVarUse(@$, $1, (Expression)$2); }	
;

// (static_type_ref::)?($)*(T_VARIABLE|${expr})[key_opt]*
chain_base:
		keyed_variable                                    { $$ = $1; }	
	|	qualified_static_type_ref T_DOUBLE_COLON keyed_variable 
	  { 
	    $$ = CreateStaticFieldUse(@$, (GenericQualifiedName)$1, (CompoundVarUse)$3); 
	  }	
;

chain_base_with_function_calls:
		chain_base	    { $$ = $1; }	
	|	function_call   { $$ = $1; }
;



// (identifier|{expr})[key_opt]*
// ($)*(T_VARIABLE|${expr})[key_opt]*
keyed_field_name:
		keyed_simple_field_name                   { $$ = $1; }	
	|	keyed_variable                            { $$ = new IndirectVarUse(@$, 1, (VariableUse)$1); }	
;

// (identifier|{expr})[key_opt]*
keyed_simple_field_name:
		keyed_simple_field_name '[' key_opt ']'   { $$ = new ItemUse(@$, (CompoundVarUse)$1, (Expression)$3); }
	|	keyed_simple_field_name '{' expr '}'		  { $$ = new ItemUse(@$, (CompoundVarUse)$1, (Expression)$3); }
	|	identifier                                { $$ = new DirectVarUse(@$, (string)$1); }
	| '{' expr '}'                              { $$ = new IndirectVarUse(@$, 1, (Expression)$2); }
;

simple_indirect_reference:
		'$'														{ $$ = 1; }
	|	simple_indirect_reference '$' { $$ = $1 + 1; }
;




assignment_list:
		assignment_list ',' assignment_list_element_opt 
		{ 
		  $$ = $1; 
		  ListAdd<Expression>($$, $3);
		}
	|	assignment_list_element_opt	
	  { 
	    $$ = NewList<Expression>($1);
	  }
;

assignment_list_element_opt:
		chain												    { $$ = $1; }							
	|	T_LIST '('  assignment_list ')'	{ $$ = new ListEx(@$, (List<Expression>)$3, null ); }
	|	/* empty */											{ $$ = null; }						
;


array_item_list_opt:
		/* empty */											{ $$ = emptyItemListIndex; }
	|	array_item_list comma_opt	      { $$ = $1; }
;

array_item_list:
		array_item_list ',' array_item
		{ 
		  $$ = $1; 
		  ListAdd<Item>($$, $3); 
		}
		
	|	array_item
		{ 
		  $$ = NewList<Item>($1);
		}
;

array_item:
    expr                                    { $$ = new ValueItem(null, (Expression)$1); }
  | expr T_DOUBLE_ARROW expr	              { $$ = new ValueItem((Expression)$1, (Expression)$3); } 
  | expr T_DOUBLE_ARROW '&' writable_chain  { $$ = new RefItem((Expression)$1, (VariableUse)$4); }
  | '&' writable_chain                      { $$ = new RefItem(null, (VariableUse)$2); }
;
 
constant_array_item_list_opt:
		/* empty */													{ $$ = emptyItemListIndex; }
	|	constant_array_item_list comma_opt  { $$ = $1; }
;

constant_array_item_list:
		constant_array_item_list ',' constant_array_item
		{ 
		  $$ = $1; 
		  ListAdd<Item>($$, $3); 
		}
		
	|	constant_array_item
		{ 
		  $$ = NewList<Item>($1);
		}
;

constant_array_item:
	  constant_inititalizer T_DOUBLE_ARROW constant_inititalizer { $$ = new ValueItem((Expression)$1, (Expression)$3); }
  | constant_inititalizer                                      { $$ = new ValueItem(null, (Expression)$1); }
;

 
 
composite_string_opt:
		composite_string_opt string_embedded_variable 
		{ 
			PhpStringBuilder sb = strBufStack.Pop();
			
			if (sb.Length > 0)
			  ListAdd<Expression>($1, sb.CreateLiteral(@$)); 
			
			ListAdd<Expression>($1, (VarLikeConstructUse)$2); 
			
			strBufStack.Push(new PhpStringBuilder(sourceUnit.Encoding, false, strBufSize)); 
			$$ = $1;
		}
		
	|	composite_string_opt T_STRING	
	  { 
	    StringUtils.StringBuilderAppend(strBufStack.Peek(), scanner.EncapsedStringBuffer, $2.Offset, $2.Integer); 
	    $$ = $1;
	  }
	  
	|	composite_string_opt T_NUM_STRING 
	  { 
	    StringUtils.StringBuilderAppend(strBufStack.Peek(), scanner.EncapsedStringBuffer, $2.Offset, $2.Integer); 
	    $$ = $1;
	  }
	  
	|	composite_string_opt T_ENCAPSED_AND_WHITESPACE	
	  { 
	    StringUtils.StringBuilderAppend(strBufStack.Peek(), scanner.EncapsedStringBuffer, $2.Offset, $2.Integer); 
	    $$ = $1;
	  }
	  
	|	composite_string_opt T_BAD_CHARACTER	
	  { 
	    StringUtils.StringBuilderAppend(strBufStack.Peek(), scanner.EncapsedStringBuffer, $2.Offset, $2.Integer); 
	    $$ = $1;
	  }
	  		
	|	composite_string_opt T_CHARACTER 
	  { 
	    strBufStack.Peek().Append((int)$2); 
	    $$ = $1;
	  }
	  
	|	composite_string_opt '['	{ strBufStack.Peek().Append('['); $$ = $1; }		
	|	composite_string_opt ']'	{ strBufStack.Peek().Append(']'); $$ = $1; }		
	|	composite_string_opt '{'	{ strBufStack.Peek().Append('{'); $$ = $1; }		
	|	composite_string_opt '}'	{ strBufStack.Peek().Append('}'); $$ = $1; }
		
	|	composite_string_opt T_OBJECT_OPERATOR 
	  { 
	    strBufStack.Peek().Append("->");
	    $$ = $1;
	  }
	   
	|	/* empty */	
	  { 
	    $$ = new List<Expression>(); 
	    strBufStack.Push(new PhpStringBuilder(sourceUnit.Encoding, false, strBufSize)); 
	  }
;


string_embedded_variable:
		T_VARIABLE														
		{ 
			$$ = new DirectVarUse(@$, (string)$1); 
		}
		
	|	T_VARIABLE '[' { strBufStack.Push(new PhpStringBuilder(sourceUnit.Encoding, false, strBufSize)); } string_embedded_key ']'
		{
			strBufStack.Pop();
			$$ = new ItemUse(@$, new DirectVarUse(@$, (string)$1),(Expression)$4);
		}
		
	|	T_VARIABLE T_OBJECT_OPERATOR T_STRING 
		{ 
			$$ = new DirectVarUse(@3, scanner.GetEncapsedString($3.Offset,$3.Integer)); 
			((DirectVarUse)$$).IsMemberOf = new DirectVarUse(@1, (string)$1); 
		}
	
	|	T_DOLLAR_OPEN_CURLY_BRACES expr '}'		
		{ 
		  $$ = new IndirectVarUse(@$, 1, (Expression)$2); 
		}
	
	|	T_DOLLAR_OPEN_CURLY_BRACES T_STRING_VARNAME '[' expr ']' '}' 
		{ 
			$$ = new ItemUse(@$, new DirectVarUse(@$, scanner.GetEncapsedString($2.Offset,$2.Integer)), (Expression)$4); 
		}
		
	|	T_CURLY_OPEN chain '}'							
		{ 
		  $$ = $2; 
		}
;

string_embedded_key:
		T_STRING		
		{ 
			/* Constants are not looked for within strings */
			$$ = new StringLiteral(@$, scanner.GetEncapsedString($1.Offset,$1.Integer));
		}
	|	T_NUM_STRING	
		{ 
			$$ = new StringLiteral(@$, scanner.GetEncapsedString($1.Offset,$1.Integer)); 
		}
	|	T_VARIABLE
	{ 
	  $$ = new DirectVarUse(@$, (string)$1); 
	}
;

%%
