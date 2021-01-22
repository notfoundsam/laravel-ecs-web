@extends('layouts.partner.auth')

@section('content')
<div class="uk-section uk-section-muted uk-flex uk-flex-middle uk-animation-fade" uk-height-viewport>
  <div class="uk-width-1-1">
    <div class="uk-container">
      <div class="uk-grid-margin uk-grid uk-grid-stack" uk-grid>
        <div class="uk-width-1-1@m">
          <div class="uk-margin uk-width-large uk-margin-auto uk-card uk-card-default uk-card-body uk-box-shadow-large">
            <h3 class="uk-card-title uk-text-center">Welcome Partner</h3>
            <form method="POST" action="{{ route('partner.login') }}">
              @csrf
              <div class="uk-margin">
                <div class="uk-inline uk-width-1-1">
                  <span class="uk-form-icon" uk-icon="icon: user"></span>
                  <input class="uk-input uk-form-large" type="email" name="email" value="{{ old('email') }}" autofocus>
                </div>
              </div>
              <div class="uk-margin">
                <div class="uk-inline uk-width-1-1">
                  <span class="uk-form-icon" uk-icon="icon: lock"></span>
                  <input class="uk-input uk-form-large" type="password" name="password">
                </div>
              </div>
              <div class="uk-margin uk-text-center">
                <label><input class="uk-checkbox" type="checkbox" name="remember" value="1"> Remember me</label>
              </div>
              <div class="uk-margin">
                <button class="uk-button uk-button-primary uk-button-large uk-width-1-1">Login</button>
              </div>
              @if ($errors->any())
                <div class="alert alert-danger">
                  <ul>
                    @foreach ($errors->all() as $error)
                      <li>{{ $error }}</li>
                    @endforeach
                  </ul>
                </div>
              @endif
              <!-- <div class="uk-text-small uk-text-center">
                Not registered? <a href="#">Create an account</a>
              </div> -->
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
@endsection
