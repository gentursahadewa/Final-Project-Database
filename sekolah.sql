USE [SEKOLAH];


DROP TABLE IF EXISTS [NILAITUGAS];
DROP TABLE IF EXISTS [NILAIULANGAN];
DROP TABLE IF EXISTS [PRESENSI];
DROP TABLE IF EXISTS [MENGAJAR];
DROP TABLE IF EXISTS [KONSULTASI];
DROP TABLE IF EXISTS [MENGIKUTI_LOMBA];
DROP TABLE IF EXISTS [MENGIKUTI_ORGANISASI];
DROP TABLE IF EXISTS [RIWAYAT_BELAJAR];
DROP TABLE IF EXISTS [PERLOMBAAN];
DROP TABLE IF EXISTS [ORGANISASI];
DROP TABLE IF EXISTS [KELAS];
DROP TABLE IF EXISTS [MAPEL];
DROP TABLE IF EXISTS [GURU];
DROP TABLE IF EXISTS [SISWA];
DROP TABLE IF EXISTS [ORTU];

CREATE TABLE [ORTU] (
	[Nik] NVARCHAR(16) NOT NULL,
	[Nama] NVARCHAR(128),
	[NoTelp] NVARCHAR(16),
	
	CONSTRAINT [PK_ORTU] PRIMARY KEY ([Nik]),
);

CREATE TABLE [SISWA] (
	[Nis] NVARCHAR(16) NOT NULL,
	[Nisn] NVARCHAR(16),
	[Nama] NVARCHAR(128),
	[Kota] NVARCHAR(128),
	[Kecamatan] NVARCHAR(128),
	[Kelurahan] NVARCHAR(128),
	[Jalan] NVARCHAR(128),
	[TempatLahir] NVARCHAR(256),
	[JenisKelamin] BIT,
	[TanggalLahir] DATE,
	[TanggalMasuk] DATE,
	[TanggalKeluar] DATE,
	[TanggalLulus] DATE,
	[NikOrtu] NVARCHAR(16) NOT NULL,
	
	CONSTRAINT [PK_SISWA] PRIMARY KEY ([Nis]),
	CONSTRAINT [FK_SISWA_ORTU] FOREIGN KEY ([NikOrtu]) REFERENCES [ORTU]([Nik]),
);


CREATE TABLE GURU(
	[KdGuru] NVARCHAR(16) NOT NULL,
	[NamaGuru] NVARCHAR(128),
	[JenisKelamin] BIT,
	
	CONSTRAINT [PK_GURU] PRIMARY KEY ([KdGuru]),
);

CREATE TABLE MAPEL(
	[NamaMapel] NVARCHAR(64) NOT NULL,
	
	CONSTRAINT [PK_MAPEL] PRIMARY KEY ([NamaMapel]),
);

CREATE TABLE [KELAS] (
	[KdKelas] NVARCHAR(16) NOT NULL,
	[NamaKelas] NVARCHAR(8),
	[TahunAjaran] INT,
	[Grade] INT,
	[KdGuru] NVARCHAR(16) NOT NULL,
	
	CONSTRAINT [PK_KELAS] PRIMARY KEY ([KdKelas]),
	CONSTRAINT [FK_KELAS_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
);

CREATE TABLE [ORGANISASI] (
	[Nama] NVARCHAR(128) NOT NULL,
	[KdGuru] NVARCHAR(16) NOT NULL,
	
	CONSTRAINT [PK_ORGANISASI] PRIMARY KEY ([Nama]),
	CONSTRAINT [FK_ORGANISASI_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
);

CREATE TABLE [PERLOMBAAN] (
	[KdLomba] NVARCHAR(16) NOT NULL,
	[Nama] NVARCHAR(128),
	[Tahun] INT,
	[Penyelenggara] NVARCHAR(128),
	[Jenjang] NVARCHAR(128),
	[KdGuru] NVARCHAR(16) NOT NULL,
	
	CONSTRAINT [PK_PERLOMBAAN] PRIMARY KEY ([KdLomba]),
	CONSTRAINT [FK_PERLOMBAAN_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
);

CREATE TABLE [RIWAYAT_BELAJAR] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[KdKelas] NVARCHAR(16) NOT NULL,
	
	CONSTRAINT [PK_RIWAYAT_BELAJAR] PRIMARY KEY ([NisSiswa], [KdKelas]),
	CONSTRAINT [FK_RIWAYAT_BELAJAR_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_RIWAYAT_BELAJAR_KELAS] FOREIGN KEY ([KdKelas]) REFERENCES [Kelas]([KdKelas]),
);

CREATE TABLE [MENGIKUTI_ORGANISASI] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[NamaOrganisasi] NVARCHAR(128) NOT NULL,
	[Jabatan] NVARCHAR(128),
	[ThKepengurusan] INT,
	
	CONSTRAINT [PK_MENGIKUTI_ORGANISASI] PRIMARY KEY ([NisSiswa], [NamaOrganisasi]),
	CONSTRAINT [FK_MENGIKUTI_ORGANISASI_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_MENGIKUTI_ORGANISASI_ORGANISASI] FOREIGN KEY ([NamaOrganisasi]) REFERENCES [ORGANISASI]([Nama]),
);

CREATE TABLE [MENGIKUTI_LOMBA] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[KdLomba] NVARCHAR(16) NOT NULL,
	
	CONSTRAINT [PK_MENGIKUTI_LOMBA] PRIMARY KEY ([NisSiswa], [KdLomba]),
	CONSTRAINT [FK_MENGIKUTI_LOMBA_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_MENGIKUTI_LOMBA_LOMBA] FOREIGN KEY ([KdLomba]) REFERENCES [PERLOMBAAN]([KdLomba]),
);

CREATE TABLE [KONSULTASI] (
	[NisSiswa] NVARCHAR(16) NOT  NULL,
	[KdGuru] NVARCHAR(16) NOT NULL,
	[MbAkademik] NVARCHAR(128),
	[MbNonAkademik] NVARCHAR(128),

	CONSTRAINT [PK_KONSULTASI] PRIMARY KEY ([NisSiswa], [KdGuru]),
	CONSTRAINT [FK_KONSULTASI_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_KONSULTASI_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
);

CREATE TABLE [MENGAJAR] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[KdGuru] NVARCHAR(16) NOT NULL,
	[KdKelas] NVARCHAR(16) NOT NULL,
	[NamaMapel] NVARCHAR(64)NOT NULL,
	[JamPerminggu] INT,
	[NilaiUts] INT,
	[NilaiUas] INT,

	CONSTRAINT [PK_MENGAJAR] PRIMARY KEY ([NisSiswa], [KdGuru], [KdKelas], [NamaMapel]),
	CONSTRAINT [FK_MENGAJAR_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_MENGAJAR_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
	CONSTRAINT [FK_MENGAJAR_MAPEL] FOREIGN KEY ([NamaMapel]) REFERENCES [MAPEL]([NamaMapel]),
	CONSTRAINT [FK_MENGAJAR_KELAS] FOREIGN KEY ([KdKelas]) REFERENCES [KELAS]([KdKElas]),
);

CREATE TABLE [PRESENSI] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[KdGuru] NVARCHAR(16) NOT NULL,
	[KdKelas] NVARCHAR(16) NOT NULL,
	[NamaMapel] NVARCHAR(64) NOT NULL,
	[Tanggal] DATE,
	[Status] NVARCHAR(16),

	CONSTRAINT [PK_PRESENSI] PRIMARY KEY ([NisSiswa], [KdGuru], [KdKelas], [NamaMapel], [Tanggal], [Status]),
	CONSTRAINT [FK_PRESENSI_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_PRESENSI_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
	CONSTRAINT [FK_PRESENSI_MAPEL] FOREIGN KEY ([NamaMapel]) REFERENCES [MAPEL]([NamaMapel]),
	CONSTRAINT [FK_PRESENSI_KELAS] FOREIGN KEY ([KdKelas]) REFERENCES [KELAS]([KdKElas]),
);


CREATE TABLE [NILAIULANGAN] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[KdGuru] NVARCHAR(16) NOT NULL,
	[KdKelas] NVARCHAR(16) NOT NULL,
	[NamaMapel] NVARCHAR(64) NOT NULL,
	[UlanganKe] INT NOT NULL,
	[Nilai] INT NOT NULL,

	CONSTRAINT [PK_NILAIULANGAN] PRIMARY KEY ([NisSiswa], [KdGuru], [KdKelas], [NamaMapel], [UlanganKe], [Nilai]),
	CONSTRAINT [FK_NILAIULANGAN_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_NILAIULANGAN_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
	CONSTRAINT [FK_NILAIULANGAN_MAPEL] FOREIGN KEY ([NamaMapel]) REFERENCES [MAPEL]([NamaMapel]),
	CONSTRAINT [FK_NILAIULANGAN_KELAS] FOREIGN KEY ([KdKelas]) REFERENCES [KELAS]([KdKElas]),
);

CREATE TABLE [NILAITUGAS] (
	[NisSiswa] NVARCHAR(16) NOT NULL,
	[KdGuru] NVARCHAR(16) NOT NULL,
	[KdKelas] NVARCHAR(16) NOT NULL,
	[NamaMapel] NVARCHAR(64) NOT NULL,
	[TugasKe] INT NOT NULL,
	[Nilai] INT NOT NULL,

	CONSTRAINT [PK_NILAITUGAS] PRIMARY KEY ([NisSiswa], [KdGuru], [KdKelas], [NamaMapel], [TugasKe], [Nilai]),
	CONSTRAINT [FK_NILAITUGAS_SISWA] FOREIGN KEY ([NisSiswa]) REFERENCES [SISWA]([Nis]),
	CONSTRAINT [FK_NILAITUGAS_GURU] FOREIGN KEY ([KdGuru]) REFERENCES [GURU]([KdGuru]),
	CONSTRAINT [FK_NILAITUGAS_MAPEL] FOREIGN KEY ([NamaMapel]) REFERENCES [MAPEL]([NamaMapel]),
	CONSTRAINT [FK_NILAITUGAS_KELAS] FOREIGN KEY ([KdKelas]) REFERENCES [KELAS]([KdKElas]),
);
