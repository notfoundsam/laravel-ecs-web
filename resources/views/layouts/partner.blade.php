<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="{{ url('/favicon.png') }}">
  <link rel="apple-touch-icon" href="{{ url('/favicon.png') }}">
  <title>@yield('title')</title>
  <!-- Styles -->
  <link rel="stylesheet" href="{{ mix('/css/partner/vendor.css') }}">
  <link rel="stylesheet" href="{{ mix('/css/partner/main.css') }}">
  <!-- Scripts -->
  <script src="{{ mix('/js/partner/main.js') }}" defer></script>
</head>
<body>
  <div id="partner_app" data-role="{{ auth()->user()->role }}">
    @include('partner.leftbar')
    <main class="content uk-background-muted" data-uk-height-viewport="expand: true">
      @yield('content')
    </main>
  </div>
</body>
</html>
