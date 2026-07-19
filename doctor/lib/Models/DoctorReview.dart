import 'dart:convert';

class DoctorReview {
  int id;
  String postedAt;
  int rating;
  String review;
  bool anonymous;
  int docId;
  int patId;
  DoctorReview(
      {required this.anonymous,
      required this.docId,
      required this.id,
      required this.patId,
      required this.postedAt,
      required this.rating,
      required this.review});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'doc_id': this.docId,
      'pat_id': this.patId,
      'id': this.id,
      'anonymous': this.anonymous,
      'posted_at': this.postedAt,
      'rating': this.rating,
      'review': this.review
    });
  }

  factory DoctorReview.fromJson(Map<String, dynamic> json) {
    return DoctorReview(
      docId: json["doc_id"],
      anonymous: json["anonymous"],
      id: json["id"],
      patId: json["pat_id"],
      postedAt: json["posted_at"],
      rating: json["rating"],
      review: json["review"]

    );
  }
}
