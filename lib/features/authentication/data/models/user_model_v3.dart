class UserModelV3 {
  int? id;
  CreatedBy? createdBy;
  CreatedBy? updatedBy;
  CreatedBy? referralBy;
  InforData? gender;
  InforData? status;
  InforData? type;
  CitizenIdentity? citizenIdentity;
  CitizenHealth? citizenHealth;
  String? updatedAt;
  String? createdAt;
  String? phoneNumber;
  String? code;
  String? fullName;
  String? email;
  String? dateOfBirth;
  String? avatar;
  String? referralCode;

  UserModelV3({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.referralBy,
    this.gender,
    this.status,
    this.type,
    this.citizenIdentity,
    this.citizenHealth,
    this.updatedAt,
    this.createdAt,
    this.phoneNumber,
    this.code,
    this.fullName,
    this.email,
    this.dateOfBirth,
    this.avatar,
    this.referralCode,
  });

  UserModelV3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    updatedBy = json['updated_by'] != null
        ? CreatedBy.fromJson(json['updated_by'])
        : null;
    referralBy = json['referral_by'];
    gender = json['gender'] != null ? InforData.fromJson(json['gender']) : null;
    status = json['status'] != null ? InforData.fromJson(json['status']) : null;
    type = json['type'] != null ? InforData.fromJson(json['type']) : null;
    citizenIdentity = json['citizen_identity'] != null
        ? CitizenIdentity.fromJson(json['citizen_identity'])
        : null;
    citizenHealth = json['citizen_health'] != null
        ? CitizenHealth.fromJson(json['citizen_health'])
        : null;
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    phoneNumber = json['phone_number'];
    code = json['code'];
    fullName = json['full_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    avatar = json['avatar'];
    referralCode = json['referral_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    if (updatedBy != null) {
      data['updated_by'] = updatedBy!.toJson();
    }
    data['referral_by'] = referralBy;
    if (gender != null) {
      data['gender'] = gender!.toJson();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (citizenIdentity != null) {
      data['citizen_identity'] = citizenIdentity!.toJson();
    }
    if (citizenHealth != null) {
      data['citizen_health'] = citizenHealth!.toJson();
    }
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['phone_number'] = phoneNumber;
    data['code'] = code;
    data['full_name'] = fullName;
    data['email'] = email;
    data['date_of_birth'] = dateOfBirth;
    data['avatar'] = avatar;
    data['referral_code'] = referralCode;
    return data;
  }
}

class CreatedBy {
  int? id;
  String? code;
  String? phoneNumber;
  String? fullName;

  CreatedBy({this.id, this.code, this.phoneNumber, this.fullName});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['phone_number'] = phoneNumber;
    data['full_name'] = fullName;
    return data;
  }
}

class InforData {
  String? label;
  String? value;

  InforData({this.label, this.value});

  InforData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class CitizenIdentity {
  int? id;
  String? nationality;
  String? ethnicity;
  String? religion;
  String? permanentAddress;
  String? currentAddress;
  String? placeOfBirth;
  String? identityNumber;
  String? oldIdentityNumber;
  String? issuePlace;
  String? issueDate;
  String? expiredDate;
  String? job;
  String? qrCode;
  bool? isVerified;

  CitizenIdentity({
    this.id,
    this.nationality,
    this.ethnicity,
    this.religion,
    this.permanentAddress,
    this.currentAddress,
    this.placeOfBirth,
    this.identityNumber,
    this.oldIdentityNumber,
    this.issuePlace,
    this.issueDate,
    this.expiredDate,
    this.job,
    this.qrCode,
    this.isVerified,
  });

  CitizenIdentity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nationality = json['nationality'];
    ethnicity = json['ethnicity'];
    religion = json['religion'];
    permanentAddress = json['permanent_address'];
    currentAddress = json['current_address'];
    placeOfBirth = json['place_of_birth'];
    identityNumber = json['identity_number'];
    oldIdentityNumber = json['old_identity_number'];
    issuePlace = json['issue_place'];
    issueDate = json['issue_date'];
    expiredDate = json['expired_date'];
    job = json['job'];
    qrCode = json['qr_code'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nationality'] = nationality;
    data['ethnicity'] = ethnicity;
    data['religion'] = religion;
    data['permanent_address'] = permanentAddress;
    data['current_address'] = currentAddress;
    data['place_of_birth'] = placeOfBirth;
    data['identity_number'] = identityNumber;
    data['old_identity_number'] = oldIdentityNumber;
    data['issue_place'] = issuePlace;
    data['issue_date'] = issueDate;
    data['expired_date'] = expiredDate;
    data['job'] = job;
    data['qr_code'] = qrCode;
    data['is_verified'] = isVerified;
    return data;
  }
}

class CitizenHealth {
  // int? id;
  String? healthInsuranceNumber;
  String? medicalIdentifier;
  String? chronicDiseases;
  String? bloodType;
  bool? disabilityStatus;

  CitizenHealth({
    // this.id,
    this.healthInsuranceNumber,
    this.medicalIdentifier,
    this.chronicDiseases,
    this.bloodType,
    this.disabilityStatus,
  });

  CitizenHealth.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    healthInsuranceNumber = json['health_insurance_number'];
    medicalIdentifier = json['medical_identifier'];
    chronicDiseases = json['chronic_diseases'];
    bloodType = json['blood_type'];
    disabilityStatus = json['disability_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['health_insurance_number'] = healthInsuranceNumber;
    data['medical_identifier'] = medicalIdentifier;
    data['chronic_diseases'] = chronicDiseases;
    data['blood_type'] = bloodType;
    data['disability_status'] = disabilityStatus;
    return data;
  }
}
