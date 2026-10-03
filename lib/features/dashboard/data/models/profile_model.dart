import 'package:mingda_app/core/utils/json_parser.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.employeeCode,
    super.fingerspotPin,
    required super.nik,
    required super.name,
    required super.gender,
    required super.birthPlace,
    required super.birthDate,
    required super.maritalStatus,
    required super.agama,
    required super.bangsa,
    required super.statusKependudukan,
    required super.tanggunganAnak,
    required super.namaIbuKandung,
    required super.ktp,
    required super.kartuKeluarga,
    required super.departmentId,
    required super.subDepartmentId,
    super.subDepartmentOld,
    required super.positionId,
    required super.joinDate,
    required super.employmentStatus,
    required super.serikat,
    required super.lulusanSekolah,
    required super.workScheduleId,
    super.supervisorId,
    super.salaryBase,
    required super.bank,
    required super.nomorRekening,
    required super.taxNpwp,
    required super.bpjsKesehatan,
    required super.bpjsKetenagakerjaan,
    required super.address,
    required super.city,
    required super.province,
    required super.desa,
    required super.kecamatan,
    required super.kabupaten,
    required super.postalCode,
    required super.phone,
    required super.email,
    required super.emergencyContactName,
    required super.emergencyContactPhone,
    required super.userId,
    required super.status,
    super.tanggalResign,
    super.tanggalMangkir,
    super.tanggalGagalProbation,
    super.tanggalPending,
    required super.profilePhoto,
    required super.createdAt,
    required super.updatedAt,
    required super.shiftType,
    required super.profilePhotoUrl,
    required super.department,
    required super.position,
    required super.workSchedule,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    return ProfileModel(
      id: parseIntValue(data['id']),
      employeeCode: data['employee_code'] ?? '',
      fingerspotPin: data['fingerspot_pin'],
      nik: data['nik'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      birthPlace: data['birth_place'] ?? '',
      birthDate: data['birth_date'] ?? '',
      maritalStatus: data['marital_status'] ?? '',
      agama: data['agama'] ?? '',
      bangsa: data['bangsa'] ?? '',
      statusKependudukan: data['status_kependudukan'] ?? '',
      tanggunganAnak: parseIntValue(data['tanggungan_anak']),
      namaIbuKandung: data['nama_ibu_kandung'] ?? '',
      ktp: data['ktp'] ?? '',
      kartuKeluarga: data['kartu_keluarga'] ?? '',
      departmentId: parseIntValue(data['department_id']),
      subDepartmentId: parseIntValue(data['sub_department_id']),
      subDepartmentOld: data['sub_department_old'],
      positionId: parseIntValue(data['position_id']),
      joinDate: data['join_date'] ?? '',
      employmentStatus: data['employment_status'] ?? '',
      serikat: data['serikat'] ?? '',
      lulusanSekolah: data['lulusan_sekolah'] ?? '',
      workScheduleId: parseIntValue(data['work_schedule_id']),
      supervisorId: data['supervisor_id'] == null
          ? null
          : parseIntValue(data['supervisor_id']),
      salaryBase: data['salary_base'] == null
          ? null
          : parseDoubleValue(data['salary_base']),
      bank: data['bank'] ?? '',
      nomorRekening: data['nomor_rekening'] ?? '',
      taxNpwp: data['tax_npwp'] ?? '',
      bpjsKesehatan: data['bpjs_kesehatan'] ?? '',
      bpjsKetenagakerjaan: data['bpjs_ketenagakerjaan'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      desa: data['desa'] ?? '',
      kecamatan: data['kecamatan'] ?? '',
      kabupaten: data['kabupaten'] ?? '',
      postalCode: data['postal_code'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      emergencyContactName: data['emergency_contact_name'] ?? '',
      emergencyContactPhone: data['emergency_contact_phone'] ?? '',
      userId: parseIntValue(data['user_id']),
      status: data['status'] ?? '',
      tanggalResign: data['tanggal_resign'],
      tanggalMangkir: data['tanggal_mangkir'],
      tanggalGagalProbation: data['tanggal_gagal_probation'],
      tanggalPending: data['tanggal_pending'],
      profilePhoto: data['profile_photo'] ?? '',
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
      shiftType: data['shift_type'] ?? '',
      profilePhotoUrl: data['profile_photo_url'] ?? '',
      department: DepartmentModel.fromJson(data['department']),
      position: PositionModel.fromJson(data['position']),
      workSchedule: WorkScheduleModel.fromJson(data['work_schedule']),
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      employeeCode: entity.employeeCode,
      fingerspotPin: entity.fingerspotPin,
      nik: entity.nik,
      name: entity.name,
      gender: entity.gender,
      birthPlace: entity.birthPlace,
      birthDate: entity.birthDate,
      maritalStatus: entity.maritalStatus,
      agama: entity.agama,
      bangsa: entity.bangsa,
      statusKependudukan: entity.statusKependudukan,
      tanggunganAnak: entity.tanggunganAnak,
      namaIbuKandung: entity.namaIbuKandung,
      ktp: entity.ktp,
      kartuKeluarga: entity.kartuKeluarga,
      departmentId: entity.departmentId,
      subDepartmentId: entity.subDepartmentId,
      subDepartmentOld: entity.subDepartmentOld,
      positionId: entity.positionId,
      joinDate: entity.joinDate,
      employmentStatus: entity.employmentStatus,
      serikat: entity.serikat,
      lulusanSekolah: entity.lulusanSekolah,
      workScheduleId: entity.workScheduleId,
      supervisorId: entity.supervisorId,
      salaryBase: entity.salaryBase,
      bank: entity.bank,
      nomorRekening: entity.nomorRekening,
      taxNpwp: entity.taxNpwp,
      bpjsKesehatan: entity.bpjsKesehatan,
      bpjsKetenagakerjaan: entity.bpjsKetenagakerjaan,
      address: entity.address,
      city: entity.city,
      province: entity.province,
      desa: entity.desa,
      kecamatan: entity.kecamatan,
      kabupaten: entity.kabupaten,
      postalCode: entity.postalCode,
      phone: entity.phone,
      email: entity.email,
      emergencyContactName: entity.emergencyContactName,
      emergencyContactPhone: entity.emergencyContactPhone,
      userId: entity.userId,
      status: entity.status,
      tanggalResign: entity.tanggalResign,
      tanggalMangkir: entity.tanggalMangkir,
      tanggalGagalProbation: entity.tanggalGagalProbation,
      tanggalPending: entity.tanggalPending,
      profilePhoto: entity.profilePhoto,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      shiftType: entity.shiftType,
      profilePhotoUrl: entity.profilePhotoUrl,
      department: entity.department is DepartmentModel
          ? entity.department as DepartmentModel
          : DepartmentModel(
              id: entity.department.id,
              name: entity.department.name,
              description: entity.department.description,
              createdAt: entity.department.createdAt,
              updatedAt: entity.department.updatedAt,
            ),
      position: entity.position is PositionModel
          ? entity.position as PositionModel
          : PositionModel(
              id: entity.position.id,
              code: entity.position.code,
              name: entity.position.name,
              level: entity.position.level,
              description: entity.position.description,
              status: entity.position.status,
              createdAt: entity.position.createdAt,
              updatedAt: entity.position.updatedAt,
              displayName: entity.position.displayName,
            ),
      workSchedule: entity.workSchedule is WorkScheduleModel
          ? entity.workSchedule as WorkScheduleModel
          : WorkScheduleModel(
              id: entity.workSchedule.id,
              name: entity.workSchedule.name,
              startTime: entity.workSchedule.startTime,
              endTime: entity.workSchedule.endTime,
              lateTolerance: entity.workSchedule.lateTolerance,
              overtimeThreshold: entity.workSchedule.overtimeThreshold,
              isActive: entity.workSchedule.isActive,
              createdAt: entity.workSchedule.createdAt,
              updatedAt: entity.workSchedule.updatedAt,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_code': employeeCode,
      'fingerspot_pin': fingerspotPin,
      'nik': nik,
      'name': name,
      'gender': gender,
      'birth_place': birthPlace,
      'birth_date': birthDate,
      'marital_status': maritalStatus,
      'agama': agama,
      'bangsa': bangsa,
      'status_kependudukan': statusKependudukan,
      'tanggungan_anak': tanggunganAnak,
      'nama_ibu_kandung': namaIbuKandung,
      'ktp': ktp,
      'kartu_keluarga': kartuKeluarga,
      'department_id': departmentId,
      'sub_department_id': subDepartmentId,
      'sub_department_old': subDepartmentOld,
      'position_id': positionId,
      'join_date': joinDate,
      'employment_status': employmentStatus,
      'serikat': serikat,
      'lulusan_sekolah': lulusanSekolah,
      'work_schedule_id': workScheduleId,
      'supervisor_id': supervisorId,
      'salary_base': salaryBase,
      'bank': bank,
      'nomor_rekening': nomorRekening,
      'tax_npwp': taxNpwp,
      'bpjs_kesehatan': bpjsKesehatan,
      'bpjs_ketenagakerjaan': bpjsKetenagakerjaan,
      'address': address,
      'city': city,
      'province': province,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'postal_code': postalCode,
      'phone': phone,
      'email': email,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'user_id': userId,
      'status': status,
      'tanggal_resign': tanggalResign,
      'tanggal_mangkir': tanggalMangkir,
      'tanggal_gagal_probation': tanggalGagalProbation,
      'tanggal_pending': tanggalPending,
      'profile_photo': profilePhoto,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'shift_type': shiftType,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DepartmentModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const DepartmentModel(
        id: 0,
        name: '-',
        description: '-',
        createdAt: '',
        updatedAt: '',
      );
    }
    return DepartmentModel(
      id: parseIntValue(json['id']),
      name: json['name']?.toString() ?? '-',
      description: json['description']?.toString() ?? '-',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}

class PositionModel extends PositionEntity {
  const PositionModel({
    required super.id,
    required super.code,
    required super.name,
    super.level,
    required super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.displayName,
  });

  factory PositionModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const PositionModel(
        id: 0,
        code: '-',
        name: '-',
        description: '-',
        status: '-',
        createdAt: '',
        updatedAt: '',
        displayName: '-',
      );
    }
    return PositionModel(
      id: parseIntValue(json['id']),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '-',
      level: json['level']?.toString(),
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      displayName: json['display_name']?.toString() ??
          json['name']?.toString() ??
          '-',
    );
  }
}

class WorkScheduleModel extends WorkScheduleEntity {
  const WorkScheduleModel({
    required super.id,
    required super.name,
    required super.startTime,
    required super.endTime,
    required super.lateTolerance,
    required super.overtimeThreshold,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WorkScheduleModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const WorkScheduleModel(
        id: 0,
        name: 'Reguler',
        startTime: '08:00',
        endTime: '17:00',
        lateTolerance: 15,
        overtimeThreshold: 30,
        isActive: true,
        createdAt: '',
        updatedAt: '',
      );
    }
    return WorkScheduleModel(
      id: parseIntValue(json['id']),
      name: json['name']?.toString() ?? 'Reguler',
      startTime: json['start_time']?.toString() ?? '08:00',
      endTime: json['end_time']?.toString() ?? '17:00',
      lateTolerance: parseIntValue(json['late_tolerance']),
      overtimeThreshold: parseIntValue(json['overtime_threshold']),
      isActive: parseBoolValue(json['is_active']),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
