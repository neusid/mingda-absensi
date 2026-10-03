class ProfileEntity {
  final int id;
  final String employeeCode;
  final String? fingerspotPin;
  final String nik;
  final String name;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final String maritalStatus;
  final String agama;
  final String bangsa;
  final String statusKependudukan;
  final int tanggunganAnak;
  final String namaIbuKandung;
  final String ktp;
  final String kartuKeluarga;
  final int departmentId;
  final int subDepartmentId;
  final String? subDepartmentOld;
  final int positionId;
  final String joinDate;
  final String employmentStatus;
  final String serikat;
  final String lulusanSekolah;
  final int workScheduleId;
  final int? supervisorId;
  final double? salaryBase;
  final String bank;
  final String nomorRekening;
  final String taxNpwp;
  final String bpjsKesehatan;
  final String bpjsKetenagakerjaan;
  final String address;
  final String city;
  final String province;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String postalCode;
  final String phone;
  final String email;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final int userId;
  final String status;
  final String? tanggalResign;
  final String? tanggalMangkir;
  final String? tanggalGagalProbation;
  final String? tanggalPending;
  final String profilePhoto;
  final String createdAt;
  final String updatedAt;
  final String shiftType;
  final String profilePhotoUrl;
  final DepartmentEntity department;
  final PositionEntity position;
  final WorkScheduleEntity workSchedule;

  const ProfileEntity({
    required this.id,
    required this.employeeCode,
    this.fingerspotPin,
    required this.nik,
    required this.name,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.maritalStatus,
    required this.agama,
    required this.bangsa,
    required this.statusKependudukan,
    required this.tanggunganAnak,
    required this.namaIbuKandung,
    required this.ktp,
    required this.kartuKeluarga,
    required this.departmentId,
    required this.subDepartmentId,
    this.subDepartmentOld,
    required this.positionId,
    required this.joinDate,
    required this.employmentStatus,
    required this.serikat,
    required this.lulusanSekolah,
    required this.workScheduleId,
    this.supervisorId,
    this.salaryBase,
    required this.bank,
    required this.nomorRekening,
    required this.taxNpwp,
    required this.bpjsKesehatan,
    required this.bpjsKetenagakerjaan,
    required this.address,
    required this.city,
    required this.province,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.userId,
    required this.status,
    this.tanggalResign,
    this.tanggalMangkir,
    this.tanggalGagalProbation,
    this.tanggalPending,
    required this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
    required this.shiftType,
    required this.profilePhotoUrl,
    required this.department,
    required this.position,
    required this.workSchedule,
  });

  ProfileEntity copyWith({
    int? id,
    String? employeeCode,
    String? fingerspotPin,
    String? nik,
    String? name,
    String? gender,
    String? birthPlace,
    String? birthDate,
    String? maritalStatus,
    String? agama,
    String? bangsa,
    String? statusKependudukan,
    int? tanggunganAnak,
    String? namaIbuKandung,
    String? ktp,
    String? kartuKeluarga,
    int? departmentId,
    int? subDepartmentId,
    String? subDepartmentOld,
    int? positionId,
    String? joinDate,
    String? employmentStatus,
    String? serikat,
    String? lulusanSekolah,
    int? workScheduleId,
    int? supervisorId,
    double? salaryBase,
    String? bank,
    String? nomorRekening,
    String? taxNpwp,
    String? bpjsKesehatan,
    String? bpjsKetenagakerjaan,
    String? address,
    String? city,
    String? province,
    String? desa,
    String? kecamatan,
    String? kabupaten,
    String? postalCode,
    String? phone,
    String? email,
    String? emergencyContactName,
    String? emergencyContactPhone,
    int? userId,
    String? status,
    String? tanggalResign,
    String? tanggalMangkir,
    String? tanggalGagalProbation,
    String? tanggalPending,
    String? profilePhoto,
    String? createdAt,
    String? updatedAt,
    String? shiftType,
    String? profilePhotoUrl,
    DepartmentEntity? department,
    PositionEntity? position,
    WorkScheduleEntity? workSchedule,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      fingerspotPin: fingerspotPin ?? this.fingerspotPin,
      nik: nik ?? this.nik,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      agama: agama ?? this.agama,
      bangsa: bangsa ?? this.bangsa,
      statusKependudukan: statusKependudukan ?? this.statusKependudukan,
      tanggunganAnak: tanggunganAnak ?? this.tanggunganAnak,
      namaIbuKandung: namaIbuKandung ?? this.namaIbuKandung,
      ktp: ktp ?? this.ktp,
      kartuKeluarga: kartuKeluarga ?? this.kartuKeluarga,
      departmentId: departmentId ?? this.departmentId,
      subDepartmentId: subDepartmentId ?? this.subDepartmentId,
      subDepartmentOld: subDepartmentOld ?? this.subDepartmentOld,
      positionId: positionId ?? this.positionId,
      joinDate: joinDate ?? this.joinDate,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      serikat: serikat ?? this.serikat,
      lulusanSekolah: lulusanSekolah ?? this.lulusanSekolah,
      workScheduleId: workScheduleId ?? this.workScheduleId,
      supervisorId: supervisorId ?? this.supervisorId,
      salaryBase: salaryBase ?? this.salaryBase,
      bank: bank ?? this.bank,
      nomorRekening: nomorRekening ?? this.nomorRekening,
      taxNpwp: taxNpwp ?? this.taxNpwp,
      bpjsKesehatan: bpjsKesehatan ?? this.bpjsKesehatan,
      bpjsKetenagakerjaan: bpjsKetenagakerjaan ?? this.bpjsKetenagakerjaan,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      desa: desa ?? this.desa,
      kecamatan: kecamatan ?? this.kecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      tanggalResign: tanggalResign ?? this.tanggalResign,
      tanggalMangkir: tanggalMangkir ?? this.tanggalMangkir,
      tanggalGagalProbation: tanggalGagalProbation ?? this.tanggalGagalProbation,
      tanggalPending: tanggalPending ?? this.tanggalPending,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shiftType: shiftType ?? this.shiftType,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      department: department ?? this.department,
      position: position ?? this.position,
      workSchedule: workSchedule ?? this.workSchedule,
    );
  }
}

class DepartmentEntity {
  final int id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}

class PositionEntity {
  final int id;
  final String code;
  final String name;
  final String? level;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String displayName;

  const PositionEntity({
    required this.id,
    required this.code,
    required this.name,
    this.level,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.displayName,
  });
}

class WorkScheduleEntity {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final int lateTolerance;
  final int overtimeThreshold;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const WorkScheduleEntity({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.lateTolerance,
    required this.overtimeThreshold,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
