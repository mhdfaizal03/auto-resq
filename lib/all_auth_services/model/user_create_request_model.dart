class UserCreateRequestModel {
  final String userName;
  final String workshopName;
  final String status;
  final String date;
  final String time;
  final String place;
  final String phoneNo;
  final List<dynamic> services;
  final String assignedMechanicName;
  final String issueText;
  final String location;
  final bool isPaid;
  final String id;
  final String description;
  final String userEmail;
  final String amount;

  UserCreateRequestModel(
      {required this.userName,
      required this.workshopName,
      required this.status,
      required this.date,
      required this.time,
      required this.place,
      required this.phoneNo,
      required this.services,
      required this.assignedMechanicName,
      required this.issueText,
      required this.location,
      required this.isPaid,
      required this.id,
      required this.description,
      required this.userEmail,
      required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'workshopName': workshopName,
      'status': status,
      'date': date,
      'time': time,
      'place': place,
      'phoneNo': phoneNo,
      'services': services,
      'assignedMechanicName': assignedMechanicName,
      'issueText': issueText,
      'location': location,
      'isPaid': isPaid,
      'id': id,
      'description': description,
      'userEmail': userEmail,
      'amount': amount
    };
  }

  factory UserCreateRequestModel.fromMap(Map<String, dynamic> map) {
    return UserCreateRequestModel(
        userName: map['userName'] ?? '',
        workshopName: map['workshopName'] ?? '',
        status: map['status'] ?? '',
        date: map['date'] ?? '',
        time: map['time'] ?? '',
        place: map['place'] ?? '',
        phoneNo: map['phoneNo'] ?? '',
        services: List<String>.from(map['services'] ?? []),
        assignedMechanicName: map['assignedMechanicName'] ?? '',
        issueText: map['issueText'] ?? '',
        location: map['location'] ?? '',
        isPaid: map['isPaid'] ?? false,
        id: map['id'] ?? '',
        description: map['description'] ?? '',
        userEmail: map['userEmail'] ?? '',
        amount: map['amount'] ?? 0.0);
  }
}
