// import 'package:gql/ast.dart';
// import 'package:equatable/equatable.dart';
//
// abstract class JsonSerializable {
//   Map<String, dynamic> toJson();
// }
//
// abstract class GraphQLQuery<T, U> extends Equatable {
//   const GraphQLQuery();
//   DocumentNode get document;
//   String get operationName;
//
//   T parse(Map<String, dynamic> json);
//
//   Map<String, dynamic> getVariables(U variables) {
//       if (variables is JsonSerializable) {
//           return (variables as JsonSerializable).toJson();
//       }
//       return {};
//   }
// }
