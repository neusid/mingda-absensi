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
