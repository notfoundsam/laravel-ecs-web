<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="{{ url('/favicon.png') }}">
  <link rel="apple-touch-icon" href="{{ url('/favicon.png') }}">
  <title>Login</title>
  <!-- Styles -->
  <link href="{{ mix('/css/admin/auth.css') }}" rel="stylesheet">
  <!-- Scripts -->
  <script src="{{ mix('/js/admin/auth.js') }}" defer></script>
</head>
<body>
  @yield('content')
</body>
</html>
