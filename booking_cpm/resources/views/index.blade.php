@extends('layouts.app')

@section('content')

<div class="container">

```
<h2 class="mb-4">Dashboard Smart Parking</h2>

<div class="row mb-4">

    <div class="col-md-3">
        <div class="card">
            <div class="card-body text-center">
                <h5>Total User</h5>
                <h3>{{ $totalUser }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card">
            <div class="card-body text-center">
                <h5>Total Booking</h5>
                <h3>{{ $totalBooking }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card">
            <div class="card-body text-center">
                <h5>Mobil Masuk</h5>
                <h3>{{ $checkedIn }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card">
            <div class="card-body text-center">
                <h5>Pendapatan</h5>
                <h3>Rp {{ number_format($income) }}</h3>
            </div>
        </div>
    </div>

</div>

<div class="card mb-4">

    <div class="card-header">
        Data Lantai Parkir
    </div>

    <div class="card-body">

        <table class="table table-bordered">

            <thead>
                <tr>
                    <th>Lantai</th>
                    <th>Kapasitas</th>
                    <th>Terisi</th>
                    <th>Sisa</th>
                </tr>
            </thead>

            <tbody>

            @foreach($floors as $floor)

                <tr>

                    <td>{{ $floor->name }}</td>

                    <td>{{ $floor->capacity }}</td>

                    <td>{{ $floor->occupied ?? 0 }}</td>

                    <td>
                        {{ $floor->capacity - ($floor->occupied ?? 0) }}
                    </td>

                </tr>

            @endforeach

            </tbody>

        </table>

    </div>

</div>

<div class="card mb-4">

    <div class="card-header">
        Monitoring Slot Parkir
    </div>

    <div class="card-body">

        <table class="table table-striped">

            <thead>
                <tr>
                    <th>Slot</th>
                    <th>Lantai</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

            @forelse($slots as $slot)

                <tr>

                    <td>{{ $slot->kode_slot }}</td>

                    <td>{{ $slot->floor->name ?? '-' }}</td>

                    <td>

                        @if($slot->status == 'available')

                            <span class="badge bg-success">
                                Kosong
                            </span>

                        @elseif($slot->status == 'booked')

                            <span class="badge bg-warning">
                                Dibooking
                            </span>

                        @else

                            <span class="badge bg-danger">
                                Terisi
                            </span>

                        @endif

                    </td>

                </tr>

            @empty

                <tr>
                    <td colspan="3" class="text-center">
                        Belum ada data slot
                    </td>
                </tr>

            @endforelse

            </tbody>

        </table>

    </div>

</div>

<div class="card mb-4">

    <div class="card-header">
        Booking Terbaru
    </div>

    <div class="card-body">

        <table class="table table-bordered">

            <thead>
                <tr>
                    <th>Kode Booking</th>
                    <th>User</th>
                    <th>Slot</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

            @forelse($bookings as $booking)

                <tr>

                    <td>{{ $booking->booking_code }}</td>

                    <td>{{ $booking->user->name ?? '-' }}</td>

                    <td>{{ $booking->slot->kode_slot ?? '-' }}</td>

                    <td>{{ $booking->status }}</td>

                </tr>

            @empty

                <tr>
                    <td colspan="4" class="text-center">
                        Belum ada data booking
                    </td>
                </tr>

            @endforelse

            </tbody>

        </table>

    </div>

</div>

<div class="card">

    <div class="card-header">
        Verifikasi DP
    </div>

    <div class="card-body">

        <table class="table table-bordered">

            <thead>
                <tr>
                    <th>Booking</th>
                    <th>User</th>
                    <th>DP</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

            @forelse($payments as $payment)

                <tr>

                    <td>{{ $payment->booking->booking_code ?? '-' }}</td>

                    <td>{{ $payment->booking->user->name ?? '-' }}</td>

                    <td>Rp {{ number_format($payment->amount) }}</td>

                    <td>{{ $payment->status }}</td>

                </tr>

            @empty

                <tr>
                    <td colspan="4" class="text-center">
                        Belum ada data pembayaran
                    </td>
                </tr>

            @endforelse

            </tbody>

        </table>

    </div>

</div>
```

</div>

@endsection
