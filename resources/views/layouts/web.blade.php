<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="{{ url('/favicon.png') }}">
  <link rel="apple-touch-icon" href="{{ url('/favicon.png') }}">
  @yield('meta')
  <title>@yield('title')</title>
  @yield('ld-json')
  <!-- Styles -->
  <link rel="stylesheet" href="{{ mix('/css/web/main.css') }}">
  @yield('styles')
  @include('common.gtag')
  @yield('scripts')
</head>
<body>
  <header class="header"></header>
  <div class="relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0">
    @yield('content')
  </div>
  <footer class="footer"></footer>
</body>
</html>
