<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="{{ url('/favicon.png') }}">
  <link rel="apple-touch-icon" href="{{ url('/favicon.png') }}">
  <title>@yield('title')</title>
  <!-- Styles -->
  <link rel="stylesheet" href="{{ mix('/css/admin/vendor.css') }}">
  <link rel="stylesheet" href="{{ mix('/css/admin/main.css') }}">
  <!-- Scripts -->
  <script src="{{ mix('/js/admin/main.js') }}" defer></script>
</head>
<body>
  <div id="admin_app" data-role="{{ auth()->user()->role }}">
    @include('admin.leftbar')
    @include('admin.offcanvas')
    @include('admin.topbar')
    <main class="content uk-background-muted" data-uk-height-viewport="expand: true">
      @yield('content')
    </main>
  </div>
</body>
</html>
