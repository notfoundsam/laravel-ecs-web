<aside class="left-bar uk-light uk-visible@m">
  <div class="left-nav-wrap">
    <ul class="uk-nav uk-nav-default uk-nav-parent-icon" data-uk-nav="">
      @if(auth()->user()->role == App\Models\PartnerUser::ADMIN)
        <li class="uk-nav-header">{{ trans('partner.leftbar.partner') }}</li>
        <li class="{{ request()->is('partner/users') ? 'uk-open' : '' }}"><a href="{{ route('partner.users.index') }}"><span class="item"><span data-uk-icon="icon: users" class="uk-margin-small-right"></span>@lang('partner.leftbar.users')</span></a></li>
        <li class="{{ request()->is('partner/vue_users') ? 'uk-open' : '' }}"><a href="{{ route('partner.vue_users.index') }}"><span class="item"><span data-uk-icon="icon: code" class="uk-margin-small-right"></span>@lang('partner.leftbar.vue_users')</span></a></li>
        <li class="{{ request()->is('partner/tests') ? 'uk-open' : '' }}"><a href="{{ route('partner.users.index') }}"><span class="item"><span data-uk-icon="icon: code" class="uk-margin-small-right"></span>@lang('partner.leftbar.tests')</span></a></li>
        <li class="{{ request()->is('partner/tests') ? 'uk-open' : '' }}"><a href="{{ route('partner.users.index') }}"><span class="item"><span data-uk-icon="icon: code" class="uk-margin-small-right"></span>@lang('partner.leftbar.tests')</span></a></li>
      @endif
    </ul>

    <form action="{{ route('partner.logout') }}" method="POST" class="lang-padding">
      @csrf
      <button type="submit" class="uk-width-expand uk-button uk-button-small uk-button-primary" type="submit">@lang('partner.leftbar.logout_btn')</button>
    </form>
  </div>
</aside>
