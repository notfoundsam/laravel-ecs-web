@extends('layouts.admin')

@section('title', __('admin.users.title'))

@section('content')
  <div class="uk-container uk-container-expand">
    <div class="uk-flex uk-flex-right uk-margin-top">
      <a class="uk-button uk-button-primary" href="{{ route('admin.users.create') }}">New</a>
    </div>
    <div class="uk-card uk-card-default uk-card-small uk-card-body uk-margin-bottom uk-margin-top uk-overflow-auto">
      <table class="uk-table uk-table-small uk-table-divider">
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Active</th>
          </tr>
        </thead>
        <tbody>
          @foreach ($users as $user)
            <tr>
              <td>{{ $user->name }}</td>
              <td>{{ $user->email }}</td>
              <td>{{ $user->role }}</td>
              <td>{{ $user->active }}</td>
            </tr>
          @endforeach
        </tbody>
      </table>
    </div>
  </div>
@endsection
