class ParkingSlot {
  final int id;
  final int floorId;
  final String kodeSlot;
  final String status; // available, booked, occupied

  ParkingSlot({required this.id, required this.floorId, required this.kodeSlot, required this.status});

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'],
      floorId: json['floor_id'],
      kodeSlot: json['kode_slot'],
      status: json['status'],
    );
  }

  bool get isAvailable => status == 'available';
  bool get isBooked => status == 'booked';
  bool get isOccupied => status == 'occupied';
}