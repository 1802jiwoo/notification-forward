// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ChannelTypeAdapter extends TypeAdapter<ChannelType> {
  @override
  final typeId = 0;

  @override
  ChannelType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChannelType.email;
      case 1:
        return ChannelType.discord;
      case 2:
        return ChannelType.slack;
      case 3:
        return ChannelType.sms;
      default:
        return ChannelType.email;
    }
  }

  @override
  void write(BinaryWriter writer, ChannelType obj) {
    switch (obj) {
      case ChannelType.email:
        writer.writeByte(0);
      case ChannelType.discord:
        writer.writeByte(1);
      case ChannelType.slack:
        writer.writeByte(2);
      case ChannelType.sms:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiscordChannelAdapter extends TypeAdapter<DiscordChannel> {
  @override
  final typeId = 1;

  @override
  DiscordChannel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscordChannel(
      id: (fields[1] as num).toInt(),
      type: fields[2] as ChannelType,
      name: fields[3] as String,
      isActive: fields[4] as bool,
      webhookUrl: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DiscordChannel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.webhookUrl)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscordChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailChannelAdapter extends TypeAdapter<EmailChannel> {
  @override
  final typeId = 2;

  @override
  EmailChannel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailChannel(
      id: (fields[5] as num).toInt(),
      type: fields[6] as ChannelType,
      name: fields[7] as String,
      isActive: fields[8] as bool,
      senderEmail: fields[0] as String,
      smtpHost: fields[1] as String,
      smtpPort: fields[2] as String,
      appPassword: fields[3] as String,
      recipientEmails: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EmailChannel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.senderEmail)
      ..writeByte(1)
      ..write(obj.smtpHost)
      ..writeByte(2)
      ..write(obj.smtpPort)
      ..writeByte(3)
      ..write(obj.appPassword)
      ..writeByte(4)
      ..write(obj.recipientEmails)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SlackChannelAdapter extends TypeAdapter<SlackChannel> {
  @override
  final typeId = 3;

  @override
  SlackChannel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlackChannel(
      id: (fields[1] as num).toInt(),
      type: fields[2] as ChannelType,
      name: fields[3] as String,
      isActive: fields[4] as bool,
      webhookUrl: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SlackChannel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.webhookUrl)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlackChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmsChannelAdapter extends TypeAdapter<SmsChannel> {
  @override
  final typeId = 4;

  @override
  SmsChannel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmsChannel(
      id: (fields[1] as num).toInt(),
      type: fields[2] as ChannelType,
      name: fields[3] as String,
      isActive: fields[4] as bool,
      recipientPhoneNumber: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SmsChannel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.recipientPhoneNumber)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FilterAdapter extends TypeAdapter<Filter> {
  @override
  final typeId = 5;

  @override
  Filter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Filter(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      phoneNumber: fields[2] as String?,
      keywords: (fields[3] as List).cast<String>(),
      keywordTarget: fields[4] as KeywordMatchTarget,
      channelIds: (fields[5] as List).cast<int>(),
      isActive: fields[6] as bool,
      targetApps: (fields[8] as List).cast<InstalledApp>(),
    );
  }

  @override
  void write(BinaryWriter writer, Filter obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.keywords)
      ..writeByte(4)
      ..write(obj.keywordTarget)
      ..writeByte(5)
      ..write(obj.channelIds)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.targetApps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KeywordMatchTargetAdapter extends TypeAdapter<KeywordMatchTarget> {
  @override
  final typeId = 6;

  @override
  KeywordMatchTarget read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return KeywordMatchTarget.titleOnly;
      case 1:
        return KeywordMatchTarget.bodyOnly;
      case 2:
        return KeywordMatchTarget.titleOrBody;
      default:
        return KeywordMatchTarget.titleOnly;
    }
  }

  @override
  void write(BinaryWriter writer, KeywordMatchTarget obj) {
    switch (obj) {
      case KeywordMatchTarget.titleOnly:
        writer.writeByte(0);
      case KeywordMatchTarget.bodyOnly:
        writer.writeByte(1);
      case KeywordMatchTarget.titleOrBody:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeywordMatchTargetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstalledAppAdapter extends TypeAdapter<InstalledApp> {
  @override
  final typeId = 7;

  @override
  InstalledApp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstalledApp(
      packageName: fields[0] as String,
      appName: fields[1] as String,
      icon: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, InstalledApp obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.packageName)
      ..writeByte(1)
      ..write(obj.appName)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstalledAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
