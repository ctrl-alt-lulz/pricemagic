// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import {Page, Card, Button, Thumbnail} from '@shopify/polaris';

// const Hello = props => (
//   <div>Hello {props.name}!</div>
// )

// Hello.defaultProps = {
//   name: 'David'
// }

// Hello.propTypes = {
//   name: PropTypes.string
// }

// document.addEventListener('DOMContentLoaded', () => {
//   ReactDOM.render(
//     <Hello name="React" />,
//     document.body.appendChild(document.createElement('div')),
//   )
// })

const Hello = props => (
  <Page title="Products">
    {props.products.map((product, index) => (
    <Card key={index}
      title={product.title}
      primaryFooterAction={{
        content: 'View',
        url: 'https://${shop_session.url}/admin/products/${product.id}',
      }}
      sectioned
    >
        <Thumbnail
          source={product.images[0].src}
          alt={product.title}
          size="large"
        />
      
    </Card>   
    ))}
  </Page>
)
// Render component with data
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<Hello {...data} />, node)
})