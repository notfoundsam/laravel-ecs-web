<div class="left-nav-wrap">
  <ul class="uk-nav uk-nav-default uk-nav-parent-icon" data-uk-nav="">
    @if(auth()->user()->role == App\Models\AdminUser::ADMIN)
      <li class="uk-nav-header">{{ trans('admin.leftbar.admin') }}</li>
      <li class="{{ request()->is('admin/users') ? 'uk-open' : '' }}"><a href="{{ route('admin.users.index') }}"><span class="item"><span data-uk-icon="icon: users" class="uk-margin-small-right"></span>@lang('admin.leftbar.users')</span></a></li>
      <li class="{{ request()->is('admin/vue_users') ? 'uk-open' : '' }}"><a href="{{ route('admin.vue_users.index') }}"><span class="item"><span data-uk-icon="icon: code" class="uk-margin-small-right"></span>@lang('admin.leftbar.vue_users')</span></a></li>
      <li class="{{ request()->is('admin/tests') ? 'uk-open' : '' }}"><a href="{{ route('admin.users.index') }}"><span class="item"><span data-uk-icon="icon: code" class="uk-margin-small-right"></span>@lang('admin.leftbar.tests')</span></a></li>
      <li class="{{ request()->is('admin/tests') ? 'uk-open' : '' }}"><a href="{{ route('admin.users.index') }}"><span class="item"><span data-uk-icon="icon: code" class="uk-margin-small-right"></span>@lang('admin.leftbar.tests')</span></a></li>
    @endif
  </ul>

  <form action="{{ route('admin.logout') }}" method="POST" class="lang-padding">
    @csrf
    <button type="submit" class="uk-width-expand uk-button uk-button-small uk-button-primary" type="submit">@lang('admin.leftbar.logout_btn')</button>
  </form>
</div>
