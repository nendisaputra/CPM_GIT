@extends('layouts.app')

@section('content')

<h2>Detail Booking</h2>

<div class="card">

    <div class="card-body">

        <p>
            <b>Kode Booking :</b>
            {{ $booking->booking_code }}
        </p>

        <p>
            <b>Nama :</b>
            {{ $booking->user->name }}
        </p>

        <p>
            <b>Plat Nomor :</b>
            {{ $booking->user->plate_number }}
        </p>

        <p>
            <b>Slot :</b>
            {{ $booking->slot->kode_slot }}
        </p>

        <p>
            <b>Status :</b>
            {{ $booking->status }}
        </p>

    </div>

</div>

@endsection

