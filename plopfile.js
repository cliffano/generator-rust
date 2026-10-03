export default function (plop) {

  plop.setHelper('copyrightYear', function () {
    return new Date().getFullYear();
  });

  plop.setHelper('underline', function (char, length) {
    return char.repeat(length);
  });

  plop.setHelper('titlecase', function (text) {
    return text.charAt(0).toUpperCase() + text.slice(1);
  });

  plop.setHelper('uppercase', function (text) {
    return text.toUpperCase();
  });

  plop.setHelper('prefixConst', function (text) {
    return text.toUpperCase().replace(/\s+/g, '').replace(/[^A-Z]/g, '_');
  });

  plop.setHelper('snakecase', function (text) {
    return text.toLowerCase().replace(/[^a-z0-9]+/g, '_');
  });

  const prompts = [
    {
      type: 'input',
      name: 'project_id',
      message: 'Project ID'
    },
    {
      type: 'input',
      name: 'project_name',
      message: 'Project Name'
    },
    {
      type: 'input',
      name: 'project_desc',
      message: 'Project Description '
    },
    {
      type: 'input',
      name: 'author_name',
      message: 'Author Name'
    },
    {
      type: 'input',
      name: 'author_email',
      message: 'Author Email'
    },
    {
      type: 'input',
      name: 'author_url',
      message: 'Author URL'
    },
    {
      type: 'input',
      name: 'github_id',
      message: 'GitHub ID'
    },
    {
      type: 'input',
      name: 'github_repo',
      message: 'GitHub Repository'
    },
    {
      type: 'input',
      name: 'github_token_prefix',
      message: 'GitHub Actions token prefix'
    }
  ];

  plop.setGenerator('rust-cli', {
    description: 'Rust-cli Plop',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage',
        templateFiles: [
          'templates/rust-cli/.*/*/*/*',
          'templates/rust-cli/.*/*/*',
          'templates/rust-cli/**/.*',
          'templates/rust-cli/**/*'
        ]
      }
    ]
  });

  plop.setGenerator('rust-cli-partials', {
    description: 'Rust-cli partials template',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage/rust-cli-partials',
        templateFiles: [
          'templates/rust-cli-partials/*'
        ],
        base: 'templates/rust-cli-partials'
      }
    ]
  });

  plop.setGenerator('rust-lib', {
    description: 'Rust-lib Plop',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage',
        templateFiles: [
          'templates/rust-lib/.*/*/*/*',
          'templates/rust-lib/.*/*/*',
          'templates/rust-lib/**/.*',
          'templates/rust-lib/**/*'
        ]
      }
    ]
  });

  plop.setGenerator('rust-lib-partials', {
    description: 'Rust-lib partials template',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage/rust-lib-partials',
        templateFiles: [
          'templates/rust-lib-partials/*'
        ],
        base: 'templates/rust-lib-partials'
      }
    ]
  });
};
