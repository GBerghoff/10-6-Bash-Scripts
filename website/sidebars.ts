import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  // By default, Docusaurus generates a sidebar from the docs folder structure
  scriptsSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Scripts',
      items: [
        'scripts/scripts-index',
        {
          type: 'category',
          label: 'Monitoring',
          items: [
            {
              type: 'category',
              label: 'Alerts',
              items: [
                'scripts/monitoring/alerts/disk-space-alert',
              ],
            },
          ],
        },
        {
          type: 'category',
          label: 'Utils',
          items: [
            'scripts/utils/pomodoro-timer',
          ],
        },
      ],
    }
  ],
};

export default sidebars;
