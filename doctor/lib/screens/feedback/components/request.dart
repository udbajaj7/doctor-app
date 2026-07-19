import 'dart:convert';

import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';

Future<String> submitFeedback(int patId, int rating, String comment) async {
  final response = await ConnectionService().returnConnection().post(
        Uri.parse(writeFeedbackUrl),
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "user_id": patId,
          "rating": rating,
          "comment": comment
        }),
      );
  if (response.statusCode == 200) {
    return "Success";
  } else {
    return "Some error occurred in submitting Feedback";
  }
}
